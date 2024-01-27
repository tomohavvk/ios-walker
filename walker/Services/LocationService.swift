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
        if !isUpdatingLocation {
            locationManager.startUpdatingLocation()
       //     locationManager.startUpdatingHeading()
            isUpdatingLocation = true
        }
    }
    func stop() {
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

    
    @Published public var currentLocation: MapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    ))
    
    
    override init() {
        super.init()
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    func startWatcher(distanceFilter: Double) {
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
            
            // It appears that setting manager.distanceFilter to 0 can prevent
            // subsequent location updates. See issue #88.
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
        // CLLocationManager requires main thread
        DispatchQueue.main.async {
            self.watcher.locationManager.stopUpdatingLocation()
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
                

                currentLocation =    MapCameraPosition.region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                ))
                
//                currentLocation.camera =
              
                //   currentLocation = location
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
