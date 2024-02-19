//
//  LocationWatcherView.swift
//  walker
//
//  Created by IZ on 03.02.2024.
//

import CoreLocation
import Foundation
import SwiftUI

class LocationWatcherModel: ObservableObject {
  @Published var lastLocation: CLLocation?
}
