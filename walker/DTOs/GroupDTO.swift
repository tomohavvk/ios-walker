//
//  Group.swift
//  walker
//
//  Created by IZ on 15.02.2024.
//

import Foundation
import SwiftUI

class GroupDTO: Identifiable, Decodable, ObservableObject {
  @Published var id: String
  @Published var ownerDeviceId: String
  @Published var name: String
  @Published var deviceCount: Int
  @Published var isPublic: Bool
  @Published var isJoined: Bool
  @Published var createdAt: String

  init(
    id: String, ownerDeviceId: String, name: String, deviceCount: Int, isPublic: Bool,
    isJoined: Bool, createdAt: String
  ) {
    self.id = id
    self.ownerDeviceId = ownerDeviceId
    self.name = name
    self.deviceCount = deviceCount
    self.isPublic = isPublic
    self.isJoined = isJoined
    self.createdAt = createdAt
  }

  // Add Decodable conformance
  private enum CodingKeys: String, CodingKey {
    case id
    case ownerDeviceId
    case name
    case deviceCount
    case isPublic
    case isJoined
    case createdAt
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    ownerDeviceId = try container.decode(String.self, forKey: .ownerDeviceId)
    name = try container.decode(String.self, forKey: .name)
    deviceCount = try container.decode(Int.self, forKey: .deviceCount)
    isPublic = try container.decode(Bool.self, forKey: .isPublic)
    isJoined = try container.decode(Bool.self, forKey: .isJoined)
    createdAt = try container.decode(String.self, forKey: .createdAt)
  }
}

var groupsTesting = [
  GroupDTO(
    id: UUID().uuidString, ownerDeviceId: "device_id", name: "Walker Group 1", deviceCount: 3,
    isPublic: true, isJoined: true, createdAt: "2024"),
  GroupDTO(
    id: UUID().uuidString, ownerDeviceId: "device_id", name: "Walker Group 2", deviceCount: 2,
    isPublic: true, isJoined: false, createdAt: "2024"),
  GroupDTO(
    id: UUID().uuidString, ownerDeviceId: "device_id", name: "Walker Group 3", deviceCount: 11111,
    isPublic: true, isJoined: false, createdAt: "2024"),
  GroupDTO(
    id: UUID().uuidString, ownerDeviceId: "device_id", name: "Walker Group 4", deviceCount: 6,
    isPublic: true, isJoined: true, createdAt: "2024"),
]
