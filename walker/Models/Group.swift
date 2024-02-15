//
//  Group.swift
//  walker
//
//  Created by IZ on 15.02.2024.
//

import Foundation
import SwiftUI

struct Group: Identifiable, Codable {
    var id : String
    var ownerDeviceId: String
    var name: String
    var deviceCount: Int
    var isPrivate: Bool
    var createdAt: String
}

var groupsTesting = [
    Group(id : UUID().uuidString, ownerDeviceId: "device_id", name: "Walker Group 1", deviceCount: 3, isPrivate:  true, createdAt: "2024"),
    Group(id : UUID().uuidString, ownerDeviceId: "device_id", name: "Walker Group 2", deviceCount: 2, isPrivate:  true, createdAt: "2024"),
    Group(id : UUID().uuidString, ownerDeviceId: "device_id", name: "Walker Group 3", deviceCount: 11111, isPrivate:  true, createdAt: "2024"),
    Group(id : UUID().uuidString, ownerDeviceId: "device_id", name: "Walker Group 4", deviceCount: 6, isPrivate:  true, createdAt: "2024")
  
]
