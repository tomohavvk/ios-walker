//
//  LocationWatcherView.swift
//  walker
//
//  Created by IZ on 03.02.2024.
//

import Foundation
import SwiftUI
import CoreLocation

class LocationWatcherModel: ObservableObject {
    @Published var lastLocation: CLLocation?
}
