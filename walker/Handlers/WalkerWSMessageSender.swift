//
//  WalkerWSMEssageSender.swift
//  walker
//
//  Created by IZ on 19.02.2024.
//

import Foundation


import SwiftUI
import Combine

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
    
    func getGroups(limit: Int, offset: Int) {
        let message = GroupsGet(limit: limit, offset: offset)
        
        do {
            walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
        } catch {
            print("Error sending device location: \(error)")
        }
    }
    
        
    func searchGroups(search: String, limit: Int, offset: Int) {
        let message = GroupsSearch(search: search, limit: limit, offset: offset)
        
        do {
            walkerApp.walkerWS.sendWebSocketMessage(try encodeMessage(message))
        } catch {
            print("Error sending device location: \(error)")
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
    case group_join
    case groups_get
    case groups_search
}
