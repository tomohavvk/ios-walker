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

class NavigationService : ObservableObject{
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: LocationWatcherService.self))
    
    @ObservedObject var navigationModel: NavigationViewModel
    @ObservedObject var mapModel: MapViewModel
    @ObservedObject var locationService: LocationWatcherService
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(navigationModel: NavigationViewModel,  mapModel: MapViewModel, locationService: LocationWatcherService) {
        self.navigationModel = navigationModel
        self.mapModel = mapModel
        self.locationService = locationService
    }
    
    func start() {
        if navigationModel.followLocation || navigationModel.recordLocation {
            locationService.startWatcher()
        }
        
        handleFollowLocation()
        handleRecordLocation()
        handleCurrentPosition()
    }
    
    fileprivate func handleFollowLocation() {
        navigationModel.$followLocation.sink{_ in  self.locationService.startWatcher()}.store(in: &cancellables)
    }
    
    fileprivate func handleRecordLocation() {
        navigationModel.$recordLocation.sink{ [] isRecordLocation in
            Self.logger.info("isRecordLocation")
        }
        .store(in: &cancellables)
    }
    
    fileprivate func handleCurrentPosition() {
        locationService.$currentLocation.sink{ [] currentLocation in
            if let location = currentLocation {
                withAnimation {
                    self.mapModel.position = location.asCameraPosition()
                }
            }
        }
        .store(in: &cancellables)
    }
}
