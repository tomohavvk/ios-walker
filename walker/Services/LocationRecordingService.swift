//
//  NavigationService.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import Combine
import CoreLocation
import Foundation
import Get
import OSLog
import SwiftUI

class LocationRecordingService: ObservableObject {
  private static let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: String(describing: LocationRecordingService.self))

  @ObservedObject var locationService: LocationWatcherService

  private var locationsBuffer: [CLLocation] = []

  private var cancellables: Set<AnyCancellable> = []

  init(locationService: LocationWatcherService) {
    print("INIT LocationRecordingService")
    self.locationService = locationService
  }

  func start() {
    handleLocationChange()
  }

  fileprivate func handleLocationChange() {
    locationService.model.$lastLocation.sink { [] currentLocation in
      if let location = currentLocation {
        if location.horizontalAccuracy <= 5 {
          self.locationsBuffer.append(location)

          Task {
            LocationHistoryDataManager.shared.saveLocationHistory(location.asLocationDTO())

            if self.locationsBuffer.count >= 5 {

              walkerApp.wsMessageSender.sendDeviceLocation(
                self.locationsBuffer.map({ location in
                  location.asLocationDTO()
                }))

              self.locationsBuffer.removeAll()
            }
          }
        }
      }
    }
    .store(in: &cancellables)
  }
}
