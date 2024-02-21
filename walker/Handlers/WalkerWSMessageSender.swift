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
    let message = LocationPersist(locations)

    do {
      walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
    } catch {
      print("Error sending device location: \(error)")
    }
  }

  func createGroup(
    id: String, name: String, isPublic: Bool, publicId: String?, description: String?
  ) {
    let message = GroupCreate(
      id: id, name: name, isPublic: isPublic, publicId: publicId, description: description)

    do {
      walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
    } catch {
      print("Error creating group: \(error)")
    }
  }

  func joinGroup(groupId: String) {
    let message = GroupJoin(groupId: groupId)

    do {
      walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
    } catch {
      print("Error joining group: \(error)")
    }
  }

  func getGroups(limit: Int, offset: Int) {
    let message = GroupsGet(limit: limit, offset: offset)

    do {
      walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
    } catch {
      print("Error getting groups: \(error)")
    }
  }

  func searchGroups(search: String, limit: Int, offset: Int) {
    let message = GroupsSearch(search: search, limit: limit, offset: offset)

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

struct LocationPersist: Encodable {
  let type: MessageOutType = MessageOutType.location_persist
  let locations: [LocationDTO]

  init(_ locations: [LocationDTO]) {
    self.locations = locations
  }
}

struct GroupCreate: Encodable {
  let type: MessageOutType = MessageOutType.group_create
  let id: String
  let name: String
  let isPublic: Bool
  let publicId: String?
  let description: String?

  init(id: String, name: String, isPublic: Bool, publicId: String?, description: String?) {
    self.id = id
    self.name = name
    self.isPublic = isPublic
    self.publicId = publicId
    self.description = description
  }
}

struct GroupJoin: Encodable {
  let type: MessageOutType = MessageOutType.group_join
  let groupId: String

  init(groupId: String) {
    self.groupId = groupId
  }
}

struct GroupsGet: Encodable {
  let type: MessageOutType = MessageOutType.groups_get
  let limit: Int
  let offset: Int

  init(limit: Int, offset: Int) {
    self.limit = limit
    self.offset = offset
  }
}

struct GroupsSearch: Encodable {
  let type: MessageOutType = MessageOutType.groups_search
  let search: String
  let limit: Int
  let offset: Int

  init(search: String, limit: Int, offset: Int) {
    self.search = search
    self.limit = limit
    self.offset = offset
  }
}

enum MessageOutType: String, Encodable {
  case location_persist
  case group_create
  case group_join
  case groups_get
  case groups_search
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
