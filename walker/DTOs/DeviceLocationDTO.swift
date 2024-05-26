//
//  DeviceLocationDTO.swift
//  walker
//
//  Created by Ihor Zadyra on 26.05.2024.
//

struct DeviceLocationDTO: Codable {
  var deviceId: String
  var latitude: Double
  var longitude: Double
  var accuracy: Double
  var speed: Double
  var time: String
  var altitude: Double?
  var altitudeAccuracy: Double?
  var bearing: Double?
}
