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
  @ObservedObject private var groupMessagesModel: GroupMessagesModel
  @ObservedObject private var createGroupModel: CreateGroupModel
  @ObservedObject private var locationWatcherModel: LocationWatcherModel

  private let decoder = JSONDecoder()
  private var lastGroupsFilterValue = "init"
  private var cancellables: Set<AnyCancellable> = []

    init(groupSheetModel: GroupSheetModel, groupMessagesModel: GroupMessagesModel, createGroupModel: CreateGroupModel, locationWatcherModel: LocationWatcherModel) {
    print("INIT WalkerWSMessageHandler")

    self.groupSheetModel = groupSheetModel
    self.groupMessagesModel = groupMessagesModel
    self.createGroupModel = createGroupModel
    self.locationWatcherModel = locationWatcherModel
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

      case .PersistLocationIn:
        _ = try decoder.decode(LocationPersistIn.self, from: data)

        print("LocationPersisted")

      case .CreateGroupIn:
        let group = try decoder.decode(CreateGroupIn.self, from: data)

        self.groupSheetModel.groupsToShow.insert(group.data, at: 0)
          
        print("GroupCreated")

      case .CreateGroupMessageIn:
        let message = try decoder.decode(CreateGroupMessageIn.self, from: data)
        let groupId =   message.data.groupId

          if let index = self.groupSheetModel.groupsToShow.firstIndex(where: { $0.id == groupId }) {
              
              print("update updatedAt of group")
              self.groupSheetModel.groupsToShow[index].updatedAt = message.data.createdAt
          }
          
          self.groupMessagesModel.messagesToShow.insert(message.data, at: groupMessagesModel.messagesToShow.count)
        print("CreateGroupMessageIn")

      case .GetGroupMessagesIn:
        let message = try decoder.decode(GetGroupMessagesIn.self, from: data)

          self.groupMessagesModel.messagesToShow = message.data
          self.groupMessagesModel.messagesToShow.reverse()
        print("GetGroupMessagesIn")

      case .GroupJoinedIn:
        _ = try decoder.decode(JoinGroupIn.self, from: data)

        print("JoinGroupIn")

      case .GetGroupsIn:
        let result = try decoder.decode(GetGroupsIn.self, from: data)

        print("GetGroupsIn")
        self.groupSheetModel.groupsToShow = result.data

      case .GroupDevicesLocationsIn:
        let result = try decoder.decode(GroupDevicesLocationsIn.self, from: data)

        print("GroupDevicesLocationsIn")
        self.locationWatcherModel.groupDevicesLocations = result.data


      case .SearchGroupsIn:
        let result = try decoder.decode(SearchGroupsIn.self, from: data)

        print("SearchGroupsIn")
        self.groupSheetModel.groupsToShow = result.data

      case .IsPublicIdAvailableIn:
        let result = try decoder.decode(IsPublicIdAvailableIn.self, from: data)
          createGroupModel.lastPublicIdAvailability = result.data.available
        createGroupModel.isCheckingPubicAvailability = false
          print("IsPublicIdAvailableIn:", result.data.available)

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
            walkerApp.wsMessageSender.searchGroups(filter: trimmed, limit: 200, offset: 0)

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
  case PersistLocationIn = "persist_location"
  case CreateGroupIn = "create_group"
  case GroupDevicesLocationsIn = "group_devices_locations"
  case CreateGroupMessageIn = "create_group_message"
  case GetGroupMessagesIn = "get_group_messages"
  case GroupJoinedIn = "join_group"
  case GetGroupsIn = "get_groups"
  case SearchGroupsIn = "search_groups"
  case IsPublicIdAvailableIn = "is_public_id_available"
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

struct LocationPersistIn: WSMessageIn {
  var type: MessageInType = .PersistLocationIn
}

struct CreateGroupIn: WSMessageIn {
  var type: MessageInType = .CreateGroupIn
  let data: GroupDTO
}

struct GroupDevicesLocationsIn: WSMessageIn {
  var type: MessageInType = .GroupDevicesLocationsIn
  let data: [DeviceLocationDTO]
}

struct JoinGroupIn: WSMessageIn {
  var type: MessageInType = .GroupJoinedIn
  let data: DeviceGroup
}

struct GetGroupsIn: WSMessageIn {
  var type: MessageInType = .GetGroupsIn
  let data: [GroupDTO]
}


struct CreateGroupMessageIn: WSMessageIn {
  var type: MessageInType = .CreateGroupMessageIn
  let data: GroupMessageDTO
}

struct GetGroupMessagesIn: WSMessageIn {
  var type: MessageInType = .GetGroupMessagesIn
  let data: [GroupMessageDTO]
}

struct SearchGroupsIn: WSMessageIn {
  var type: MessageInType = .SearchGroupsIn
  let data: [GroupDTO]
}

struct IsPublicIdAvailableInData: Decodable {
  let available: Bool
    
    init(available: Bool) {
        self.available = available
    }
}

struct IsPublicIdAvailableIn: WSMessageIn {
  var type: MessageInType = .IsPublicIdAvailableIn
  let data: IsPublicIdAvailableInData
    
}

struct DeviceGroup: Decodable {
  let deviceId: String
  let groupId: String
  let createdAt: String
}
