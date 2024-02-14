//
//  WalkerClient.swift
//  walker
//
//  Created by IZ on 14.02.2024.
//

import Foundation
import SwiftUI
import Combine
import OSLog
import CoreLocation
import Get

class WalkerClient {
    
    
    private let devideId: String
    private let walkerServiceClient: APIClient
    private let locationDispatcherServiceClient: APIClient
    
    init(baseURL: String, deviceId: String) {
        self.devideId = deviceId
        self.walkerServiceClient = APIClient(baseURL: URL(string:"http://92.118.77.33:9001"))
        self.locationDispatcherServiceClient = APIClient(baseURL: URL(string:"http://92.118.77.33:9000"))
    }
    
    func sendLocationData(_ locations: [CLLocation]) async  throws{
        do {
            try await locationDispatcherServiceClient.send(Request(path: "/api/v1/devices/"+devideId+"/location", method: .post, body: locations.map{location in location.asLocationDTO()}, headers: ["Content-Type": "application/json", "X-Trace-Id": "953a5959-1b0f-412a-bdab-1cbe15486a28"]))
        } catch {
            print("Error encoding request body: \(error)")
            return
        }
    }
}
