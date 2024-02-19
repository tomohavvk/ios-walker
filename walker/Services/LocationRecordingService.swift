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
   
    
    private var locationsBuffer: [CLLocation] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init( locationService: LocationWatcherService ) {
        print("INIT LocationRecordingService")
        self.locationService = locationService
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
                        
                        if self.locationsBuffer.count >= 5 {
                            
                              walkerApp.wsMessageSender.sendDeviceLocation(self.locationsBuffer.map({ location in
                                location.asLocationDTO()
                            }))
                            
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
