//
//  WalkerWS.swift
//  walker
//
//  Created by IZ on 18.02.2024.
//


import Foundation
import SwiftUI
import Combine
import OSLog
import CoreLocation
import Get

class WalkerWS: ObservableObject {
    private let encoder = JSONEncoder()
    private let deviceId: String
    
    @Published var messageReceived: String = ""
    
    private var webSocketTask: URLSessionWebSocketTask?
   
    
    init(deviceId: String) {
print("INIT WalkerWS")
        self.encoder.keyEncodingStrategy = .convertToSnakeCase
 
        self.deviceId = deviceId

        self.connect()
    }
    
    
    func sendWebSocketMessage(_ jsonString: String) {
        print("send WS message")
       webSocketTask?.send(.string(jsonString)) { error in
           if let error = error {
               print(error.localizedDescription)
           }
       }
   }
    
    fileprivate func connect() {
        
        guard let url = URL(string: "ws://92.118.77.33:9001/api/v1/ws/" + deviceId) else { return }
        let request = URLRequest(url: url)
        self.webSocketTask = URLSession.shared.webSocketTask(with: request)

        webSocketTask?.resume()
        receiveMessage()
        print("WS init")
    }
    
    fileprivate func reconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        
        connect()
    }
    
    fileprivate func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receive failure: \(error.localizedDescription)")

                let backoffSeconds = 5.0
                DispatchQueue.global().asyncAfter(deadline: .now() + backoffSeconds) { [weak self] in
                    print("Reconecting to websocket after:", backoffSeconds, "seconds")
                    self?.reconnect()
                    self?.receiveMessage()
                }
            case .success(let message):
                switch message {
                case .string(let text):
                
              walkerApp.walkerWS.messageReceived = text
                 
                  
                  
                case .data(let data):
                    // Handle binary data
                    break
                @unknown default:
                    break
                }
              
                // Continue receiving messages
                self?.receiveMessage()
            }
        }
    }
}


enum EncodingError: Error {
    case invalidMessage
}
