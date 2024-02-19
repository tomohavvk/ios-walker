//
//  WalkerWSMessageHandler.swift
//  walker
//
//  Created by IZ on 19.02.2024.
//

import Foundation

import SwiftUI
import Combine

class WalkerWSMessageHandler: ObservableObject {
    var lastFilterValue  =  "init"
    @State var isInit: Bool = false
    @ObservedObject var groupSheetModel: GroupSheetModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    let decoder = JSONDecoder()
    
    
    init(groupSheetModel: GroupSheetModel) {
        print("INIT WalkerWSMessageHandler")
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.groupSheetModel = groupSheetModel
        
        
    }
    
    
    
    
    func start() {
        walkerApp.walkerWS.$messageReceived.sink { message in
            DispatchQueue.main.async {
                self.handleMessage(message)
            }
           
        }.store(in: &cancellables)
        
        
        
        self.groupSheetModel.$searchingFor
            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
            .sink { [] filter in
                print("groupSheetModel.searchingFor", filter)
                if self.lastFilterValue != filter && !filter.isEmpty {
                    Task {
                        do {
                            self.lastFilterValue = filter
                            print("$searchingFor.GET DATA FROM SERVER", filter)
                            
                            walkerApp.wsMessageSender.searchGroups(search: filter, limit: 1000, offset: 0)
                            
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                } else   if self.lastFilterValue != filter && filter.isEmpty {
                    self.lastFilterValue = filter
                    Task {
                        do {
                        walkerApp.wsMessageSender.getGroups(limit: 1000, offset: 0)
                    }
                    }
                }
                
            } .store(in: &cancellables)
        
        
    }
    func decodeMessage<T: WSMessageIn>(from data: Data) throws -> T {
        
        return try decoder.decode(T.self, from: data)
    }
    
    func handleMessage(_ message: String) {
     
        // Decode examples
        do {
            let anyWSMessageIn = try decoder.decode(AnyWSMessageIn.self, from: message.data(using: .utf8)!)
            
            switch anyWSMessageIn.type {
            case .LocationPersisted:
                // Handle LocationPersisted
                print("LocationPersisted")
                let result = try decoder.decode(LocationPersisted.self, from: message.data(using: .utf8)!)
              
            case .GroupJoined:
                print("GroupJoined")
                let result = try decoder.decode(GroupJoined.self, from: message.data(using: .utf8)!)
              
            case .GroupsGot:
                print("GroupsGot")
                let result = try decoder.decode(GroupsGot.self, from: message.data(using: .utf8)!)
              
                self.groupSheetModel.groupsToShow = result.groups
            case .GroupsSearched:
                print("GroupsSearched")
                let result = try decoder.decode(GroupsSearched.self, from: message.data(using: .utf8)!)
                self.groupSheetModel.groupsToShow = result.groups
              
                
            }
        } catch {
            print("Error decoding message: \(error)")
        }
    }
}


enum MessageInType: String, Codable {
    case LocationPersisted = "location_persisted"
    case GroupJoined = "group_joined"
    case GroupsGot = "groups_got"
    case GroupsSearched = "groups_searched"
}

// Wrapper struct to hold the concrete implementation of WSMessageIn
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

// Protocol for WSMessageIn
protocol WSMessageIn: Codable {
    var type: MessageInType { get }
}

// Concrete implementations for each message type
struct LocationPersisted: WSMessageIn {
    let type: MessageInType = .LocationPersisted
}

struct GroupJoined: WSMessageIn {
    let type: MessageInType = .GroupJoined
    let deviceGroup: String
}

struct GroupsGot: WSMessageIn {
    let type: MessageInType = .GroupsGot
    let groups: [Group]
}

struct GroupsSearched: WSMessageIn {
    let type: MessageInType = .GroupsSearched
    let groups: [Group]
}

//
//struct GroupsGot: Encodable {
//    let type: MessageInType = MessageOutType.groups_get
//    let limit: Int
//    let offset: Int
//
//    init(limit: Int, offset: Int) {
//        self.limit = limit
//        self.offset = offset
//    }
//}
