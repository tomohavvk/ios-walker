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
    @ObservedObject var navigationViewModel: NavigationViewModel
    @ObservedObject var locationService: LocationWatcherService
    @State var lastPolylineLocation: CLLocation?
    
    @State var polylinesToDraw: [MKPolyline] = []
    
    init(mapModel: MapViewModel, navigationModel: NavigationViewModel,locationService: LocationWatcherService) {
        self.mapModel = mapModel
        self.navigationViewModel = navigationModel
        self.locationService = locationService
    }
    
    
    func makeUIView(context: Context) -> MKMapView {
        print("makeUIView")
        let mapView: MKMapView = MKMapView()
        
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false
        mapView.showsUserTrackingButton = true
        mapView.isPitchEnabled = true
        
        mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        
        initHistoryPolyline(mapView)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        DispatchQueue.main.async {
            if !polylinesToDraw.isEmpty {
                polylinesToDraw.forEach { MKPolyline in
                    mapView.addOverlay(MKPolyline)
                }
                
                polylinesToDraw.removeAll()
            }
        }
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    
    fileprivate func initHistoryPolyline(_ mapView: MKMapView) {
        let coords =  LocationHistoryDataManager.shared.fetchLocationHistory().map { history in
            CLLocationCoordinate2D(latitude: history.latitude, longitude: history.longitude)
        }
        
        if !coords.isEmpty {
            mapView.addOverlay(MKPolyline(coordinates: coords, count: coords.count))
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate{
        var cancellables: Set<AnyCancellable> = []
        
        var parent: NewView
        init(_ parent: NewView) {
            self.parent = parent
            
            parent.locationService.$lastLocation.sink { [] lastLocation in
                if  parent.navigationViewModel.recordLocation {
                    if let lastLocation = parent.locationService.lastLocation {
                        if let previousLocation = parent.lastPolylineLocation {
                            print("lastLocation.horizontalAccuracy", lastLocation.horizontalAccuracy)
                            if lastLocation.horizontalAccuracy <= 5  && parent.lastPolylineLocation?.timestamp != lastLocation.timestamp {
                                parent.lastPolylineLocation = lastLocation
                                let coords =  [
                                    CLLocationCoordinate2D(latitude: previousLocation.coordinate.latitude, longitude: previousLocation.coordinate.longitude),
                                    CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
                                ]
                                
                                parent.polylinesToDraw.append(MKPolyline(coordinates: coords, count: coords.count))
                                
                                print("NEW POLYLINE DRAWED")
                            }
                        } else {
                            parent.lastPolylineLocation = lastLocation
                        }
                    }
                }
                
            } .store(in: &cancellables)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            print("Coordinator.mapView3")
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
            
            print("Coordinator.mapView")
            
            
            return nil
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            print("Coordinator.mapView2")
            
        }
    }
}



