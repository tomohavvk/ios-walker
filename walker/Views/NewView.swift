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
    
    @ObservedObject var polylineHelper: PolylineHelper
    
    init(polylineHelper: PolylineHelper) {
        self.polylineHelper = polylineHelper
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView: MKMapView = MKMapView()
        
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false
        mapView.showsUserTrackingButton = true
        mapView.showsScale = true
        mapView.isPitchEnabled = true
        
        mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        
        polylineHelper.initHistoryPolyline(mapView)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        polylineHelper.drawPolylines(mapView)
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate{
        
        var parent: NewView
        init(_ parent: NewView) {
            self.parent = parent
            
            parent.polylineHelper.collectPolylinesToDraw(parent)
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
        
        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {}
        
        func mapViewDidStopLocatingUser(_ mapView: MKMapView) {}
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {}
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            return nil
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {}
    }
}



