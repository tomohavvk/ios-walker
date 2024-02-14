//
//  LocationService.swift
//  walker
//
//  Created by IZ on 27.01.2024.
//

import Foundation
import UIKit

import SwiftUI
import MapKit
import Combine
import CoreLocation
import OSLog
 
class Watcher {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: Watcher.self))

    let locationManager: CLLocationManager = CLLocationManager()
    private let created = Date()
    private var isUpdatingLocation: Bool = false
    
    func start() {
        Self.logger.info("start")
        if !isUpdatingLocation {
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        }
    }
    func stop() {
        Self.logger.info("stop")
        if isUpdatingLocation {
            locationManager.stopUpdatingLocation()
            isUpdatingLocation = false
        }
    }
    
    func isLocationValid(_ location: CLLocation) -> Bool {
        return location.timestamp >= created
    }
}

public class LocationWatcherService : NSObject, ObservableObject, CLLocationManagerDelegate {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: LocationWatcherService.self))

    private var watcher = Watcher()
    
    @ObservedObject  var model: LocationWatcherModel
    
    init(model: LocationWatcherModel) {
        self.model = model
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    func startWatcher(distanceFilter: Double = 30) {
        DispatchQueue.main.async {
            
            let manager = self.watcher.locationManager
            manager.delegate = self
            let externalPower = [
                .full,
                .charging
            ].contains(UIDevice.current.batteryState)
            manager.desiredAccuracy = (
                externalPower
                ? kCLLocationAccuracyBestForNavigation
                : kCLLocationAccuracyBest
            )
            
            manager.distanceFilter = distanceFilter
            manager.allowsBackgroundLocationUpdates = true
            manager.showsBackgroundLocationIndicator = true
            manager.pausesLocationUpdatesAutomatically = false
            
            let status = manager.authorizationStatus
            if [
                .notDetermined,
                .denied,
                .restricted,
            ].contains(status) {
                manager.requestWhenInUseAuthorization()
                manager.requestAlwaysAuthorization()
            }
            if ( status == .authorizedWhenInUse) {
                manager.requestAlwaysAuthorization()
            }
            return self.watcher.start()
        }
    }
    
    func stopWatcher() {
        DispatchQueue.main.async {
            self.watcher.stop()
        }
    }
    
    func openSettings() {
        DispatchQueue.main.async {
            guard let settingsUrl = URL(
                string: UIApplication.openSettingsURLString
            ) else {
                fatalError("Can't get setting url")
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: {
                    (success) in
                    if (success) {
                        
                    } else {
                        fatalError("Error during open setting url")
                    }
                })
            } else {
                fatalError("Cannot open settings")
            }
        }
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        
        if let clErr = error as? CLError {
            if clErr.code == .locationUnknown {
                return
            } else if (clErr.code == .denied) {
                watcher.stop()
                Self.logger.error("Permission denied. NOT_AUTHORIZED")
                
            }
        }
        print(error.localizedDescription)
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            if watcher.isLocationValid(location) {
                model.lastLocation = location
            }
        }
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        if status != .notDetermined {
            return watcher.start()
        }
    }
}
