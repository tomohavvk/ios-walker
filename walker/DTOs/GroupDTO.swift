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
  @Published var publicId: String?
  @Published var ownerDeviceId: String
  @Published var name: String
  @Published var deviceCount: Int
  @Published var isPublic: Bool
  @Published var isJoined: Bool
  @Published var createdAt: String
  @Published var updatedAt: String

  init(
    id: String, publicId: String?, ownerDeviceId: String, name: String, deviceCount: Int,
    isPublic: Bool,
    isJoined: Bool, createdAt: String, updatedAt: String
  ) {
    self.id = id
    self.publicId = publicId
    self.ownerDeviceId = ownerDeviceId
    self.name = name
    self.deviceCount = deviceCount
    self.isPublic = isPublic
    self.isJoined = isJoined
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
    var updatedAtDate: Date? {
          let dateFormatter = ISO8601DateFormatter()
          return dateFormatter.date(from: updatedAt)
      }
    
  // Add Decodable conformance
  private enum CodingKeys: String, CodingKey {
    case id
    case publicId
    case ownerDeviceId
    case name
    case deviceCount
    case isPublic
    case isJoined
    case createdAt
    case updatedAt
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    publicId = (try? container.decode(String.self, forKey: .publicId)) ?? nil
    ownerDeviceId = try container.decode(String.self, forKey: .ownerDeviceId)
    name = try container.decode(String.self, forKey: .name)
    deviceCount = try container.decode(Int.self, forKey: .deviceCount)
    isPublic = try container.decode(Bool.self, forKey: .isPublic)
    isJoined = try container.decode(Bool.self, forKey: .isJoined)
    createdAt = try container.decode(String.self, forKey: .createdAt)
    updatedAt = try container.decode(String.self, forKey: .updatedAt)
  }
}

