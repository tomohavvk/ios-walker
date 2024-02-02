//
//  MapViewModel.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    @Published public var position: MapCameraPosition = .automatic
    @Published var polyline: [CLLocationCoordinate2D]?
}
