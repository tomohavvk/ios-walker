//
//  Transformers.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import MapKit
import SwiftUI

extension CLLocation {
    func asCameraPosition() -> MapCameraPosition {
        return MapCameraPosition.camera( MapCamera( centerCoordinate: CLLocationCoordinate2D(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude), distance: 200, heading: self.course))
    }
    
    func asLocationDTO() -> LocationDTO {
        var simulated = false;
        if #available(iOS 15, *) {
            if self.sourceInformation != nil {
                simulated = self.sourceInformation!.isSimulatedBySoftware;
            }
        }
        return LocationDTO(
            latitude: Double(self.coordinate.latitude),
            longitude:Double(self.coordinate.longitude),
            accuracy: Double(self.horizontalAccuracy),
            altitude:Double(self.altitude),
            altitudeAccuracy:Double(self.verticalAccuracy),
            speed:Double(self.speed < 0 ? CLLocationSpeed(0) : self.speed),
            bearing: Double(self.course < 0 ? CLLocationDirection(0) : self.course),
            time:Int64(self.timestamp.timeIntervalSince1970 * 1000),
            simulated: simulated
        )
    }
}

