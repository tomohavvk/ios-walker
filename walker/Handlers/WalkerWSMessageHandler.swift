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
  @State private var isInit: Bool = false
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

    startGroupSearchHandling()
  }

  // FIXME double docoding
  func handleMessage(_ message: String) {
    do {
      guard let data = message.data(using: .utf8) else {
        print("Error converting message to data.")
        return
      }

      let anyWSMessageIn = try decoder.decode(AnyWSMessageIn.self, from: data)

      switch anyWSMessageIn.type {
      case .LocationPersisted:
        let result = try decoder.decode(LocationPersisted.self, from: data)

        print("LocationPersisted")

      case .GroupJoined:
        let result = try decoder.decode(GroupJoined.self, from: data)

        print("GroupJoined")

      case .GroupsGot:
        let result = try decoder.decode(GroupsGot.self, from: data)

        print("GroupsGot")
        self.groupSheetModel.groupsToShow = result.groups

      case .GroupsSearched:
        let result = try decoder.decode(GroupsSearched.self, from: data)

        print("GroupsSearched")
        self.groupSheetModel.groupsToShow = result.groups
      }
    } catch {
      print("Error decoding message: \(error)")
    }
  }

  fileprivate func startGroupSearchHandling() {
    self.groupSheetModel.$searchingFor
      .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
      .sink { [] filter in
        if self.lastGroupsFilterValue != filter && !filter.isEmpty {
          Task {
            self.lastGroupsFilterValue = filter
            walkerApp.wsMessageSender.searchGroups(search: filter, limit: 1000, offset: 0)

          }
        } else if self.lastGroupsFilterValue != filter && filter.isEmpty {
          self.lastGroupsFilterValue = filter
          Task {
            walkerApp.wsMessageSender.getGroups(limit: 1000, offset: 0)
          }
        }
      }.store(in: &cancellables)
  }
}

enum MessageInType: String, Codable {
  case LocationPersisted = "location_persisted"
  case GroupJoined = "group_joined"
  case GroupsGot = "groups_got"
  case GroupsSearched = "groups_searched"
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

protocol WSMessageIn: Codable {
  var type: MessageInType { get }
}

struct LocationPersisted: WSMessageIn {
  var type: MessageInType = .LocationPersisted
}

struct GroupJoined: WSMessageIn {
  var type: MessageInType = .GroupJoined
  let deviceGroup: String
}

struct GroupsGot: WSMessageIn {
  var type: MessageInType = .GroupsGot
  let groups: [GroupDTO]
}

struct GroupsSearched: WSMessageIn {
  var type: MessageInType = .GroupsSearched
  let groups: [GroupDTO]
}
