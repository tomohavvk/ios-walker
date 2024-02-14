//
//  NavigationService.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import Foundation
import SwiftUI
import Combine
import OSLog
import CoreLocation
import Get

class LocationRecordingService : ObservableObject{
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: LocationRecordingService.self))
    
    @ObservedObject var locationService: LocationWatcherService
   private let walkerClient: WalkerClient
    
    private var locationsBuffer: [CLLocation] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init( locationService: LocationWatcherService, walkerClient: WalkerClient) {
        self.locationService = locationService
        self.walkerClient = walkerClient
    }
    
    func start() {
//        recordLocation()
        handleLocationChange()
    }
//
//    fileprivate func recordLocation() {
//        instrumentModel.$recordLocation.sink{ [] isRecordLocation in
//            Self.logger.info("isRecordLocation")
//            
//            if isRecordLocation {
//                self.locationService.startWatcher()
//            } else {
//                self.locationService.stopWatcher()
//            }
//        }
//        .store(in: &cancellables)
//    }
    
    fileprivate func handleLocationChange() {
        locationService.model.$lastLocation.sink{ [] currentLocation in
            if let location = currentLocation {
//                self.instrumentModel.currentAltitude = Int(location.altitude)
                if location.horizontalAccuracy <= 5   {
                    //                    self.instrumentModel.currentSpeed = Int(location.speed * 3.6)
                    self.locationsBuffer.append(location)
                    
                    Task {
                        LocationHistoryDataManager.shared.saveLocationHistory(location.asLocationDTO())
                        
                        if self.locationsBuffer.count >= 10 {
                            
                            try await self.walkerClient.sendLocationData(self.locationsBuffer)
                            
                            self.locationsBuffer.removeAll()
                        }
                    }
                }
//                else if location.horizontalAccuracy > 5 {
//                    self.instrumentModel.currentSpeed = 0
//                }
            }
        }
        .store(in: &cancellables)
    }
}
