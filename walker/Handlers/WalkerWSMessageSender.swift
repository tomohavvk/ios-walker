//
//  WalkerWSMEssageSender.swift
//  walker
//
//  Created by IZ on 19.02.2024.
//

import Combine
import Foundation
import SwiftUI

class WalkerWSMessageSender {
  private let encoder = JSONEncoder()

  init() {
    print("INIT WalkerWSMessageSender")
    self.encoder.keyEncodingStrategy = .convertToSnakeCase
  }

  func sendDeviceLocation(_ locations: [LocationDTO]) {
    let message = LocationPersistOut(locations)

    do {
      walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
    } catch {
      print("Error sending device location: \(error)")
    }
  }

  func createGroup(
    id: String, name: String, isPublic: Bool, publicId: String?, description: String?
  ) {
    let message = CreateGroupOut(
      id: id, name: name, isPublic: isPublic, publicId: publicId, description: description)

    do {
      walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
    } catch {
      print("Error creating group: \(error)")
    }
  }

  func createGroupMessage(
    groupId: String, message: String
  ) {
    let message = CreateGroupMessageOut(
        groupId: groupId, message: message)

    do {
      walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
    } catch {
      print("Error creating group message: \(error)")
    }
  }
    
  func getGroupMessages(
    groupId: String,limit: Int, offset: Int
  ) {
    let message = GetGroupMessagesOut(groupId: groupId, limit: limit, offset: offset)

    do {
      walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
    } catch {
      print("Error getting group messages: \(error)")
    }
  }

  func joinGroup(groupId: String) {
    let message = JoinGroup(groupId: groupId)

    do {
      walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
    } catch {
      print("Error joining group: \(error)")
    }
  }

  func getGroups(limit: Int, offset: Int) {
    let message = GetGroupsOut(limit: limit, offset: offset)

    do {
      walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
    } catch {
      print("Error getting groups: \(error)")
    }
  }

  func searchGroups(filter: String, limit: Int, offset: Int) {
    let message = SearchGroups(filter: filter, limit: limit, offset: offset)

    do {
      walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
    } catch {
      print("Error searching groups: \(error)")
    }
  }

  func checkPublicIdAvailability(publicId: String) {
    let message = IsPublicIdAvailableOut(publicId: publicId)

    do {
      walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
    } catch {
      print("Error searching groups: \(error)")
    }
  }

  fileprivate func encodeMessage<T: Encodable>(_ message: T) throws -> String {
    encoder.outputFormatting = .prettyPrinted
    let jsonData = try encoder.encode(message)

    guard let jsonString = String(data: jsonData, encoding: .utf8) else {
      throw EncodingError.invalidMessage
    }

    return jsonString
  }
}


enum MessageOutType: String, Encodable {
  case persist_location
  case create_group
  case create_group_message
  case get_group_messages
  case join_group
  case get_groups
  case search_groups
  case is_public_id_available
}

struct LocationPersistOut: Encodable {
  let type: MessageOutType = MessageOutType.persist_location
    let data: [String: [LocationDTO]]

  init(_ locations: [LocationDTO]) {
      self.data = ["locations": locations]
  }
}


struct CreateGroupData: Encodable {
  let id: String
  let name: String
  let isPublic: Bool
  let publicId: String?
  let description: String?
    
  init(id: String, name: String, isPublic: Bool, publicId: String?, description: String?) {
    self.id = id
    self.name = name
    self.description = description
    self.isPublic = isPublic
    self.publicId = publicId
  }
}


struct CreateGroupOut: Encodable {
  let type: MessageOutType = MessageOutType.create_group
  let data: CreateGroupData

  init(id: String, name: String, isPublic: Bool, publicId: String?, description: String?) {
      self.data = CreateGroupData(id: id, name: name, isPublic:isPublic, publicId:publicId, description: description)
  }
}

struct JoinGroupData: Encodable {
  let groupId: String

  init(groupId: String) {
    self.groupId = groupId
  }
}

struct JoinGroup: Encodable {
  let type: MessageOutType = MessageOutType.join_group
  let data: JoinGroupData

  init(groupId: String) {
    self.data = JoinGroupData(groupId: groupId)
  }
}


struct CreateGroupMessageData: Encodable {
  let groupId: String
  let message: String
    
  init(groupId: String, message: String) {
    self.groupId = groupId
    self.message = message
  }
}


struct CreateGroupMessageOut: Encodable {
  let type: MessageOutType = MessageOutType.create_group_message
  let data: CreateGroupMessageData

  init(groupId: String, message: String) {
      self.data = CreateGroupMessageData(groupId: groupId, message: message)
  }
}


struct GetGroupMessagesOutData: Encodable {
    let groupId: String
    let limit: Int
    let offset: Int
  
    init(groupId: String, limit: Int, offset: Int) {
      self.limit = limit
      self.offset = offset
      self.groupId = groupId
  }
}


struct GetGroupMessagesOut: Encodable {
  let type: MessageOutType = MessageOutType.get_group_messages
    let data: GetGroupMessagesOutData
    
  init(groupId: String, limit: Int, offset: Int) {
      self.data = GetGroupMessagesOutData(groupId: groupId, limit: limit, offset: offset)
  }
}

struct GetGroupsOutData: Encodable {
    let limit: Int
    let offset: Int
  
    init(limit: Int, offset: Int) {
      self.limit = limit
      self.offset = offset
  }
}


struct GetGroupsOut: Encodable {
  let type: MessageOutType = MessageOutType.get_groups
    let data: GetGroupsOutData
    
  init(limit: Int, offset: Int) {
      self.data = GetGroupsOutData(limit: limit, offset: offset)
  }
}

struct SearchGroupsData: Encodable {
  let type: MessageOutType = MessageOutType.search_groups
  let filter: String
  let limit: Int
  let offset: Int

  init(filter: String, limit: Int, offset: Int) {
    self.filter = filter
    self.limit = limit
    self.offset = offset
  }
}

struct SearchGroups: Encodable {
  let type: MessageOutType = MessageOutType.search_groups
  let data: SearchGroupsData
 

  init(filter: String, limit: Int, offset: Int) {
    self.data = SearchGroupsData(filter: filter, limit: limit, offset: offset)

  }
}


struct IsPublicIdAvailableOutData: Encodable {
  let publicId: String

  init(publicId: String) {
    self.publicId = publicId
  }
}

struct IsPublicIdAvailableOut: Encodable {
  let type: MessageOutType = MessageOutType.is_public_id_available
  let data: IsPublicIdAvailableOutData

  init(publicId: String) {
    self.data = IsPublicIdAvailableOutData(publicId: publicId)
  }
}


/// Author https://github.com/antiflasher/NanoID
class NanoID {

  private var size: Int
  private var alphabet: String

  init(alphabet: NanoIDAlphabet..., size: Int) {
    self.size = size
    self.alphabet = NanoIDHelper.parse(alphabet)
  }

  func new() -> String {
    return NanoIDHelper.generate(from: alphabet, of: size)
  }

  private static let defaultSize = 21
  private static let defaultAphabet = NanoIDAlphabet.urlSafe.toString()

  static func new() -> String {
    return NanoIDHelper.generate(from: defaultAphabet, of: defaultSize)
  }

  static func new(alphabet: NanoIDAlphabet..., size: Int) -> String {
    let charactersString = NanoIDHelper.parse(alphabet)
    return NanoIDHelper.generate(from: charactersString, of: size)
  }

  static func new(_ size: Int) -> String {
    return NanoIDHelper.generate(from: NanoID.defaultAphabet, of: size)
  }
}

private class NanoIDHelper {

  static func parse(_ alphabets: [NanoIDAlphabet]) -> String {

    var stringCharacters = ""

    for alphabet in alphabets {
      stringCharacters.append(alphabet.toString())
    }

    return stringCharacters
  }

  static func generate(from alphabet: String, of length: Int) -> String {
    var nanoID = ""

    for _ in 0..<length {
      let randomCharacter = NanoIDHelper.randomCharacter(from: alphabet)
      nanoID.append(randomCharacter)
    }

    return nanoID
  }

  static func randomCharacter(from string: String) -> Character {
    let randomNum = Int(arc4random_uniform(UInt32(string.count)))
    let randomIndex = string.index(string.startIndex, offsetBy: randomNum)
    return string[randomIndex]
  }
}

enum NanoIDAlphabet {
  case urlSafe
  case uppercasedLatinLetters
  case lowercasedLatinLetters
  case numbers

  func toString() -> String {
    switch self {
    case .uppercasedLatinLetters, .lowercasedLatinLetters, .numbers:
      return self.chars()
    case .urlSafe:
      return
        ("\(NanoIDAlphabet.uppercasedLatinLetters.chars())\(NanoIDAlphabet.lowercasedLatinLetters.chars())\(NanoIDAlphabet.numbers.chars())~_")
    }
  }

  private func chars() -> String {
    switch self {
    case .uppercasedLatinLetters:
      return "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case .lowercasedLatinLetters:
      return "abcdefghijklmnopqrstuvwxyz"
    case .numbers:
      return "1234567890"
    default:
      return ""
    }
  }
}
