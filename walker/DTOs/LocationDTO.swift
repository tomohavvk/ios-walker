//
//  LocationDto.swift
//  walker
//
//  Created by IZ on 30.01.2024.
//

import Foundation
import CoreLocation


struct LocationDTO : Codable {
      let  latitude: Double
       let longitude: Double
       let accuracy: Double
       let altitude: Double?
       let altitudeAccuracy: Double?
       let speed: Double
       let bearing: Double?
       let time: Int64
       let simulated: Bool?
}


