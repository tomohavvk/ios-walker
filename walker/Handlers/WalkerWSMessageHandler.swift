//
//  WalkerWSMessageHandler.swift
//  walker
//
//  Created by IZ on 19.02.2024.
//

import Combine
import Foundation
import SwiftUI

class WalkerWSMessageHandler: ObservableObject {

    
    
  @ObservedObject private var groupSheetModel: GroupSheetModel

  private let decoder = JSONDecoder()
  private var lastGroupsFilterValue = "init"
  private var cancellables: Set<AnyCancellable> = []

  init(groupSheetModel: GroupSheetModel) {
    print("INIT WalkerWSMessageHandler")

    self.groupSheetModel = groupSheetModel
    decoder.keyDecodingStrategy = .convertFromSnakeCase
  }

  func start() {
    walkerApp.walkerWS.$messageReceived.sink { message in
      DispatchQueue.main.async {
        self.handleMessage(message)
      }
    }.store(in: &cancellables)

    walkerApp.wsMessageSender.getGroups(limit: 100, offset: 0)

    startGroupSearchHandling()

  }

  // FIXME double docoding
  func handleMessage(_ message: String) {
    print(message)
    do {
      guard let data = message.data(using: .utf8) else {
        print("Error converting message to data.")
        return
      }

      let anyWSMessageIn = try decoder.decode(AnyWSMessageIn.self, from: data)

      switch anyWSMessageIn.type {
      case .Error:
        let error = try decoder.decode(WSError.self, from: data)

        print("WS Error:", error)

      case .LocationPersisted:
        _ = try decoder.decode(LocationPersisted.self, from: data)

        print("LocationPersisted")

      case .GroupCreated:
        let group = try decoder.decode(GroupCreated.self, from: data)
        self.groupSheetModel.groupsToShow.append(group.group)
        print("GroupCreated")

      case .GroupJoined:
        _ = try decoder.decode(GroupJoined.self, from: data)

        print("GroupJoined")

      case .GroupsGot:
        let result = try decoder.decode(GroupsGot.self, from: data)

        print("GroupsGot")
        self.groupSheetModel.groupsToShow = result.groups

      case .GroupsSearched:
        let result = try decoder.decode(GroupsSearched.self, from: data)

        print("GroupsSearched")
        self.groupSheetModel.groupsToShow = result.groups
          
      case .PublicIdAvailabilityChecked:
        let result = try decoder.decode(PublicIdAvailabilityChecked.self, from: data)
          groupSheetModel.lastPublicIdAvailability = result.available
          print("PublicIdAvailabilityChecked:", result.available)
 
      }
    } catch {
      print("Error decoding message: \(error)")
    }
  }

  fileprivate func startGroupSearchHandling() {
    self.groupSheetModel.$searchingFor
      .debounce(for: .seconds(0.4), scheduler: RunLoop.main)
      .sink { [] filter in
        let trimmed = filter.trimmingCharacters(in: .whitespaces)
        if self.lastGroupsFilterValue != trimmed && !trimmed.isEmpty {
          Task {
            self.lastGroupsFilterValue = trimmed
            walkerApp.wsMessageSender.searchGroups(search: trimmed, limit: 200, offset: 0)

          }
        } else if self.lastGroupsFilterValue != trimmed && trimmed.isEmpty {
          self.lastGroupsFilterValue = trimmed
          Task {
            walkerApp.wsMessageSender.getGroups(limit: 200, offset: 0)
          }
        }
      }.store(in: &cancellables)
  }
}

enum MessageInType: String, Codable {
  case Error = "error"
  case LocationPersisted = "location_persisted"
  case GroupCreated = "group_created"
  case GroupJoined = "group_joined"
  case GroupsGot = "groups_got"
  case GroupsSearched = "groups_searched"
  case PublicIdAvailabilityChecked = "public_id_availability_checked"
}

struct AnyWSMessageIn: Codable {
  let type: MessageInType

  enum CodingKeys: String, CodingKey {
    case type
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    type = try container.decode(MessageInType.self, forKey: .type)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(type, forKey: .type)
  }
}

protocol WSMessageIn: Decodable {
  var type: MessageInType { get }
}

struct WSError: WSMessageIn {
  var type: MessageInType = .Error
}

struct LocationPersisted: WSMessageIn {
  var type: MessageInType = .LocationPersisted
}

struct GroupCreated: WSMessageIn {
  var type: MessageInType = .GroupCreated
  let group: GroupDTO
}

struct GroupJoined: WSMessageIn {
  var type: MessageInType = .GroupJoined
  let deviceGroup: DeviceGroup
}

struct GroupsGot: WSMessageIn {
  var type: MessageInType = .GroupsGot
  let groups: [GroupDTO]
}

struct GroupsSearched: WSMessageIn {
  var type: MessageInType = .GroupsSearched
  let groups: [GroupDTO]
}

struct PublicIdAvailabilityChecked: WSMessageIn {
  var type: MessageInType = .PublicIdAvailabilityChecked
  let available: Bool
}

struct DeviceGroup: Decodable {
  let deviceId: String
  let groupId: String
  let createdAt: String
}
