import SwiftUI
import MapKit
import Combine
import CoreLocation

struct MapView: View {

    @ObservedObject var mapModel: MapViewModel
    @ObservedObject var locationService: LocationWatcherService

    var body: some View {
        Map(position: $mapModel.position) {
            UserAnnotation()
            
            if let pol = mapModel.polyline  {
                MapPolyline(coordinates: pol).stroke(.red, lineWidth: 1)
            }
        }
      
        .mapControls { MapCompass(); MapScaleView() }
        .gesture(DragGesture().onChanged { value in locationService.stopWatcher() })
        .mapStyle(.standard(elevation: .flat))
    }
}

#Preview {
    MapView(mapModel:MapViewModel(), locationService: LocationWatcherService())
}


