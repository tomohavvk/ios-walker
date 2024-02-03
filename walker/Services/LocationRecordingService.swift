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
    
    @ObservedObject var recordingModel: RecordingModel
    @ObservedObject var locationService: LocationWatcherService
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(recordingModel: RecordingModel,  locationService: LocationWatcherService) {
        self.recordingModel = recordingModel
        self.locationService = locationService
    }
    
    func start() {
        recordLocation()
        handleLocationChange()
    }

    fileprivate func recordLocation() {
        recordingModel.$recordLocation.sink{ [] isRecordLocation in
            Self.logger.info("isRecordLocation")
            
            if isRecordLocation {
                self.locationService.startWatcher()
            } else {
                self.locationService.stopWatcher()
            }
        }
        .store(in: &cancellables)
    }
    
    fileprivate func handleLocationChange() {
        locationService.model.$lastLocation.sink{ [] currentLocation in
            if let location = currentLocation {
                print("currentAltitude" , Int(location.altitude))
                self.recordingModel.currentAltitude = Int(location.altitude)
                if location.horizontalAccuracy <= 5 && self.recordingModel.recordLocation {
                    self.recordingModel.currentSpeed = Int(location.speed * 3.6)

                    Task {
                        LocationHistoryDataManager.shared.saveLocationHistory(location.asLocationDTO())
                    }
                }
            }
        }
        .store(in: &cancellables)
    }
//    
//    func fetchLocationHistory() {
//        if let deviceId = UIDevice.current.identifierForVendor {
//            Task {
//                do {
//                    let data =  try await HttpClient.send(Request<[LocationDTO]>(path: "/api/v1/geodata", method: .get,  query: [("deviceId", deviceId.uuidString)], headers: ["Content-Type": "application/json"])).value
//                    mapModel.polyline = data.map { value in
//                        CLLocationCoordinate2D(latitude: value.latitude, longitude: value.longitude)
//                    }
//                } catch {
//                    Self.logger.error("Error encoding request body: \(error)")
//                    return
//                }
//            }
//        }
//    }
//    
//    
//    func sendLocationData(_ location: CLLocation) async  throws{
//        if let devideId = UIDevice.current.identifierForVendor {
//            do {
//                try await HttpClient.send(Request(path: "/api/v1/geodata", method: .post,  query: [("deviceId", devideId.uuidString)], body: [location.asLocationDTO()], headers: ["Content-Type": "application/json"]))
//            } catch {
//                Self.logger.error("Error encoding request body: \(error)")
//                return
//            }
//        }
//    }
}
