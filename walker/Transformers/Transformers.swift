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
        return MapCameraPosition
            .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            ))
    }
}
