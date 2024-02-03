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
    
    @ObservedObject private var recordingModel: RecordingModel
    
    init(recordingModel: RecordingModel) {
        self.recordingModel = recordingModel
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var polylinesToDraw: [MKPolyline] = []
    private var drawedPolylines: [MKPolyline] = []
    
    private var lastPolylineLocation: CLLocation?
    
    public func drawPolylines(_ mapView: MKMapView) {
        print("drawPolylines", "polylinesToDraw", self.polylinesToDraw.count, "drawedPolylines", self.drawedPolylines.count)
        //  DispatchQueue.main.async {
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
        //    }
    }
    
    public func collectPolylinesToDraw(_ mapView: NewView) {
        mapView.locationWatcherModel.$lastLocation.sink { [] lastLocation in
            print("collectPolylinesToDraw", "polylinesToDraw", self.polylinesToDraw.count, "drawedPolylines", self.drawedPolylines.count)
            if self.recordingModel.recordLocation,  let lastLocation = lastLocation, let previousLocation = self.lastPolylineLocation {
                if lastLocation.horizontalAccuracy <= 5  && self.lastPolylineLocation?.timestamp != lastLocation.timestamp {
                    
                    let coords = [
                        CLLocationCoordinate2D(latitude: previousLocation.coordinate.latitude, longitude: previousLocation.coordinate.longitude),
                        CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
                    ]
                    
                    self.polylinesToDraw.append(MKPolyline(coordinates: coords, count: coords.count))
                    
                    self.lastPolylineLocation = lastLocation
                }
                
            } else {
                self.lastPolylineLocation = lastLocation
            }
            
        }.store(in: &cancellables)
    }
    
    
    public func initHistoryPolyline(_ mapView: MKMapView) {
        let coords =  LocationHistoryDataManager.shared.fetchLocationHistory().map { history in
            CLLocationCoordinate2D(latitude: history.latitude, longitude: history.longitude)
        }
        
        if !coords.isEmpty {
            mapView.addOverlay(MKPolyline(coordinates: coords, count: coords.count))
        }
    }
}
