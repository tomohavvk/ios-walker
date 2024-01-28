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



class Watcher {
    let locationManager: CLLocationManager = CLLocationManager()
    private let created = Date()
    private var isUpdatingLocation: Bool = false
    
    func start() {
        print("Watcher.start")
        if !isUpdatingLocation {
            locationManager.startUpdatingLocation()
            //  locationManager.startUpdatingHeading()
            isUpdatingLocation = true
        }
    }
    func stop() {
        print("Watcher.stop")
        if isUpdatingLocation {
            locationManager.stopUpdatingLocation()
            isUpdatingLocation = false
        }
    }
    
    func isLocationValid(_ location: CLLocation) -> Bool {
        return location.timestamp >= created
    }
}

public class BackgroundGeolocation : NSObject, ObservableObject, CLLocationManagerDelegate {
    private var watcher = Watcher()
    
    @Published public var currentLocation: CLLocation?
    
    
    override init() {
        super.init()
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    func startWatcher(distanceFilter: Double = 5) {
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
                // Attempt to escalate.
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
                print("Permission denied. NOT_AUTHORIZED")
                
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
                print("HANDLED NEW LOCATION")
                currentLocation = location
            }
        }
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        // If this method is called before the user decides on a permission, as
        // it is on iOS 14 when the permissions dialog is presented, we ignore
        // it.
        if status != .notDetermined {
            return watcher.start()
        }
    }
}
