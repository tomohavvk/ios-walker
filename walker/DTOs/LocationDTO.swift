//
//  LocationDto.swift
//  walker
//
//  Created by IZ on 30.01.2024.
//

import CoreLocation
import Foundation

struct LocationDTO: Codable {
  var latitude: Double
  var longitude: Double
  var accuracy: Double
  var speed: Double
  var time: Int64
  var altitude: Double?
  var altitudeAccuracy: Double?
  var bearing: Double?
  var simulated: Bool?
}
