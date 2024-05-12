//
//  GroupMessageDTO.swift
//  walker
//
//  Created by Ihor Zadyra on 11.05.2024.
//

import Foundation

//
//  Group.swift
//  walker
//
//  Created by IZ on 15.02.2024.
//

import Foundation
import SwiftUI

class GroupMessageDTO: Identifiable, Decodable, ObservableObject, Hashable {
  @Published var groupId: String
  @Published var authorDeviceId: String
  @Published var message: String
  @Published var createdAt: String

  init(
    groupId: String,  authorDeviceId: String, message: String, createdAt: String
  ) {
    self.groupId = groupId
    self.authorDeviceId = authorDeviceId
    self.message = message
    self.createdAt = createdAt

  }

  // Add Decodable conformance
  private enum CodingKeys: String, CodingKey {
    case groupId
    case authorDeviceId
    case message
    case createdAt
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
      groupId = try container.decode(String.self, forKey: .groupId)
      authorDeviceId = try container.decode(String.self, forKey: .authorDeviceId)
      message = try container.decode(String.self, forKey: .message)
      createdAt = try container.decode(String.self, forKey: .createdAt)

  }
    
    static func == (lhs: GroupMessageDTO, rhs: GroupMessageDTO) -> Bool {
        return lhs.createdAt == rhs.createdAt
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
    }
}
