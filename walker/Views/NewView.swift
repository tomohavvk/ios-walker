//
//  NewView.swift
//  walker
//
//  Created by IZ on 30.01.2024.
//

import SwiftUI
import MapKit
import Combine

struct NewView: UIViewRepresentable  {
    
    @ObservedObject var mapModel: MapViewModel
    @ObservedObject var locationService: LocationWatcherService
    
    init(mapModel: MapViewModel, locationService: LocationWatcherService) {
        self.mapModel = mapModel
        self.locationService = locationService
    }
    
    func makeUIView(context: Context) -> MKMapView {
        print("makeUIView")
        let mapView: MKMapView = MKMapView()
        
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
        mapView.isPitchEnabled = true
        mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
//        LocationHistoryDataManager.shared.saveLocationHistory(location: self.locationService.currentLocation)
        
        print("updateUIView")
        
        let history = LocationHistoryDataManager.shared.fetchLocationHistory()
        
        if !history.isEmpty &&  !mapModel.isPolilineHistoryAdded {
            let pols =  LocationHistoryDataManager.shared.fetchLocationHistory().map { pol in
            CLLocationCoordinate2D(latitude: pol.latitude, longitude: pol.longitude)
        }
        
//                            mapModel.polyline = data.map { value in
//                                CLLocationCoordinate2D(latitude: value.latitude, longitude: value.longitude)
//                            }
//        
 
        
                print("DRAWING", mapModel.isPolilineHistoryAdded)
                
                mapModel.isPolilineHistoryAdded = true
                
                let polyline = MKPolyline(coordinates: pols, count: pols.count)
                mapView.addOverlay(polyline)
                let polylineRect = polyline.boundingMapRect
          //      mapView.setRegion(MKCoordinateRegion(polylineRect), animated: true)
     
        }
    }
    
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate{
        var parent: NewView
        init(_ parent: NewView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = UIColor.red
                renderer.lineWidth = 1
                return renderer
            }
            
            return MKOverlayRenderer()
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            print("mapView")
            
            return nil
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            print("mapView2")
            
            
        }
        
    }
}



