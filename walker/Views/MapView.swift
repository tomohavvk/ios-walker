//
//  NewView.swift
//  walker
//
//  Created by IZ on 30.01.2024.
//

import Combine
import MapKit
import SwiftUI

struct NewView: UIViewRepresentable {

  @ObservedObject var polylineHelper: PolylineHelper

  init(polylineHelper: PolylineHelper) {
    self.polylineHelper = polylineHelper
  }

  func makeUIView(context: Context) -> MKMapView {
    print("INIT MapView")
    let mapView: MKMapView = MKMapView()

    mapView.delegate = context.coordinator
    //        mapView.showsBuildings = false
    //        mapView.showsTraffic = false
    //        mapView.isZoomEnabled = false
    //        mapView.isScrollEnabled = false
    mapView.showsUserLocation = false
    mapView.showsUserTrackingButton = true
    mapView.showsScale = true
    mapView.isPitchEnabled = true
    mapView.mapType = MKMapType.satellite

    mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)

    polylineHelper.initHistoryPolyline(mapView)

    return mapView
  }

  func updateUIView(_ mapView: MKMapView, context: Context) {
      print("update map")
    polylineHelper.drawPolylines(mapView)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, MKMapViewDelegate {

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

        if overlay is MKCircle {
          let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.green
          renderer.fillColor = UIColor.white
          renderer.lineWidth = 12
          renderer.shouldRasterize = true
          return renderer
        }

      return MKOverlayRenderer()
    }

    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {}

    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {}

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      return nil
    }

    func mapView(
      _ mapView: MKMapView, annotationView view: MKAnnotationView,
      calloutAccessoryControlTapped control: UIControl
    ) {
        
        
        print("calloutAccessoryControlTapped")
    }
  }
}
