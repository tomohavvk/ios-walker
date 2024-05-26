//
//  PolylineHelper.swift
//  walker
//
//  Created by IZ on 02.02.2024.
//

import Combine
import Foundation
import MapKit
import SwiftUI

class PolylineHelper: ObservableObject {

  @Published private var lastPolylineLocation: CLLocation?
  @ObservedObject private var locationWatcherModel: LocationWatcherModel

  private var polylinesToDraw: [MKPolyline] = []
  private var drawedPolylines: [MKPolyline] = []
  private var drawedCircles: [MKCircle] = []
  private var historyPolylines: [MKPolyline] = []

  private var cancellables: Set<AnyCancellable> = []

  init(locationWatcherModel: LocationWatcherModel) {
    self.locationWatcherModel = locationWatcherModel
      

  }

  public func drawPolylines(_ mapView: MKMapView) {

         // print(message?.count)
          DispatchQueue.main.async {

              print("self.polylinesToDraw.forEach")
      self.polylinesToDraw.forEach { polyline in
        mapView.addOverlay(polyline)
        self.drawedPolylines.append(polyline)
      }

      self.polylinesToDraw.removeAll()

      if self.drawedPolylines.count > 100 {
        mapView.removeOverlays(self.drawedPolylines)
        self.polylinesToDraw = []
        self.drawedPolylines = []

        self.initHistoryPolyline(mapView)
      }
    }
  }

  public func collectPolylinesToDraw(_ mapView: NewView) {
    locationWatcherModel.$lastLocation.sink { [] lastLocation in
      DispatchQueue.main.async {

        //    print("collectPolylinesToDraw", "polylinesToDraw", self.polylinesToDraw.count, "drawedPolylines", self.drawedPolylines.count)
        if let lastLocation = lastLocation, let previousLocation = self.lastPolylineLocation {
            print(lastLocation.horizontalAccuracy)
          if lastLocation.horizontalAccuracy <= 10
            && self.lastPolylineLocation?.timestamp != lastLocation.timestamp
          {

            let distance = self.calculateDistance(coordinates: [
              previousLocation.asLocationDTO(), lastLocation.asLocationDTO(),
            ])
            if distance <= 200 {
              let coords = [
                CLLocationCoordinate2D(
                  latitude: previousLocation.coordinate.latitude,
                  longitude: previousLocation.coordinate.longitude),
                CLLocationCoordinate2D(
                  latitude: lastLocation.coordinate.latitude,
                  longitude: lastLocation.coordinate.longitude),
              ]
                
                print("self.polylinesToDraw.append")
              self.polylinesToDraw.append(MKPolyline(coordinates: coords, count: coords.count))
            }

            self.lastPolylineLocation = lastLocation
          }

        } else {
          self.lastPolylineLocation = lastLocation
        }
      }

    }.store(in: &cancellables)
  }

  public func initHistoryPolyline(_ mapView: MKMapView) {
      
      self.locationWatcherModel.$groupDevicesLocations.sink { [] lastLocation in
      if let groupDeviceLocations = self.locationWatcherModel.groupDevicesLocations  {
          mapView.removeOverlays(self.drawedCircles)
          self.drawedCircles = []
          for location in groupDeviceLocations {
              print("ADD OVERLAY")
              let center =   CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
              let circle = MKCircle(center: center, radius: 5)
            
              mapView.addOverlay(circle)
          
              self.drawedCircles.append(circle)

              print("OVERLAY ADDED")
          }
      }
      }.store(in: &cancellables)
      
      
    mapView.removeOverlays(self.historyPolylines)
    let historyCoords = LocationHistoryDataManager.shared.fetchLocationHistory()

    let separatedByDistance = makeDataSeparatedByDistanceGap(200, historyCoords)

    print(separatedByDistance.totalDistance)
    print(separatedByDistance.result.count)
    print(
      separatedByDistance.result.map({ s in
        s.count
      }).reduce(
        0,
        { x, y in
          x + y
        }))

    separatedByDistance.result.forEach { historyCoords in
      let coords = historyCoords.map { history in
        CLLocationCoordinate2D(latitude: history.latitude, longitude: history.longitude)
      }

      if !coords.isEmpty {
        let polyline = MKPolyline(coordinates: coords, count: coords.count)
        self.historyPolylines.append(polyline)
        mapView.addOverlay(polyline)
      }
    }

  }
  struct SeparatedByGapData {
    var totalDistance: Int64
    var result: [[LocationDTO]]
  }

  func makeDataSeparatedByDistanceGap(_ gapDistanceMeters: Int64, _ trackPoints: [LocationDTO])
    -> SeparatedByGapData
  {
    var result: [[LocationDTO]] = []

    for i in 0..<trackPoints.count {
      let currentPoint = trackPoints[i]

      if i == 0 {
        result.append([currentPoint])
      } else {
        let lastGroup = result[result.count - 1]
        let lastPoint = lastGroup[lastGroup.count - 1]

        let distance = calculateDistance(coordinates: [lastPoint, currentPoint])  // Convert to meters

        if distance <= gapDistanceMeters {
          result[result.count - 1].append(currentPoint)
        } else {
          result.append([currentPoint])
        }
      }
    }

    let totalDistance = result.reduce(0) { (acc, data) in
      acc + calculateDistance(coordinates: data)
    }

    return SeparatedByGapData(totalDistance: totalDistance, result: result)
  }

  func calculateDistance(coordinates: [LocationDTO]) -> Int64 {
    let radius = 6371.0
    guard coordinates.count > 1 else {
      return 0
    }

    var totalLength = 0.0

    for i in 0..<(coordinates.count - 1) {
      let startCoord = coordinates[i]
      let endCoord = coordinates[i + 1]

      let dLat = degreesToRadians(endCoord.latitude - startCoord.latitude)
      let dLon = degreesToRadians(endCoord.longitude - startCoord.longitude)

      let a =
        sin(dLat / 2) * sin(dLat / 2) + cos(degreesToRadians(startCoord.latitude))
        * cos(degreesToRadians(endCoord.latitude)) * sin(dLon / 2) * sin(dLon / 2)

      let c = 2 * atan2(sqrt(a), sqrt(1 - a))

      let distance = radius * c
      totalLength += distance
    }

    return Int64((totalLength * 1000))
  }

  private func degreesToRadians(_ degrees: Double) -> Double {
    return degrees * .pi / 180.0
  }

}
