//
//  PolylineHelper.swift
//  walker
//
//  Created by IZ on 02.02.2024.
//

import Foundation
import SwiftUI
import MapKit
import Combine


class PolylineHelper: ObservableObject {
    
    @Published  private var lastPolylineLocation: CLLocation?
    @ObservedObject private var instrumentModel: InstrumentModel
    @ObservedObject private var locationWatcherModel: LocationWatcherModel
    
    private var polylinesToDraw: [MKPolyline] = []
    private var drawedPolylines: [MKPolyline] = []

    private var cancellables: Set<AnyCancellable> = []
    
    init(instrumentModel: InstrumentModel, locationWatcherModel: LocationWatcherModel) {
        self.instrumentModel = instrumentModel
        self.locationWatcherModel = locationWatcherModel
    }
    
    public func drawPolylines(_ mapView: MKMapView) {
        print("drawPolylines", "polylinesToDraw", self.polylinesToDraw.count, "drawedPolylines", self.drawedPolylines.count)
        DispatchQueue.main.async {
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
                if self.instrumentModel.recordLocation,  let lastLocation = lastLocation, let previousLocation = self.lastPolylineLocation {
                    if lastLocation.horizontalAccuracy <= 5  && self.lastPolylineLocation?.timestamp != lastLocation.timestamp {
                        
                        let distance = self.calculateDistance(coordinates: [previousLocation.asLocationDTO(), lastLocation.asLocationDTO()])
//                        print(lastLocation)
                        if distance <= 200 {
                            self.instrumentModel.distance += distance
                        let coords = [
                            CLLocationCoordinate2D(latitude: previousLocation.coordinate.latitude, longitude: previousLocation.coordinate.longitude),
                            CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
                        ]
                        
                        
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
        let historyCoords = LocationHistoryDataManager.shared.fetchLocationHistory()
        
        let separatedByDistance = makeDataSeparatedByDistanceGap(200, historyCoords)
        
        DispatchQueue.main.async {
            self.instrumentModel.distance = separatedByDistance.totalDistance
        }
        print(separatedByDistance.totalDistance)
        print(separatedByDistance.result.count)
        separatedByDistance.result.forEach { historyCoords in
            let coords =  historyCoords.map { history in
                CLLocationCoordinate2D(latitude: history.latitude, longitude: history.longitude)
            }
            
            if !coords.isEmpty {
                mapView.addOverlay(MKPolyline(coordinates: coords, count: coords.count))
            }
        }
        
       
    }
    struct SeparatedByGapData {
        var totalDistance: Int64
        var result: [[LocationDTO]]
    }
    
    func makeDataSeparatedByDistanceGap(_ gapDistanceMeters: Int64, _ trackPoints: [LocationDTO]) -> SeparatedByGapData {
        var result: [[LocationDTO]] = []

        for i in 0..<trackPoints.count {
            let currentPoint = trackPoints[i]

            if i == 0 {
                result.append([currentPoint])
            } else {
                let lastGroup = result[result.count - 1]
                let lastPoint = lastGroup[lastGroup.count - 1]

                let distance = calculateDistance(coordinates: [lastPoint, currentPoint]) // Convert to meters

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

            let a = sin(dLat / 2) * sin(dLat / 2) +
                    cos(degreesToRadians(startCoord.latitude)) * cos(degreesToRadians(endCoord.latitude)) *
                    sin(dLon / 2) * sin(dLon / 2)

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