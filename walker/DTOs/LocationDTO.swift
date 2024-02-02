//
//  LocationDto.swift
//  walker
//
//  Created by IZ on 30.01.2024.
//

import Foundation
import CoreLocation


struct LocationDTO : Codable {
    var latitude: Double
    var longitude: Double
    var accuracy: Double
    var altitude: Double?
    var altitudeAccuracy: Double?
    var speed: Double
    var bearing: Double?
    var time: Int64
    var simulated: Bool?
}


