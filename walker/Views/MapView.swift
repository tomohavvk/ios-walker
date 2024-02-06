import SwiftUI
import MapKit
import Combine
import CoreLocation

struct MapView: View {
    @State  var position: MapCameraPosition = .automatic
    var body: some View {
        Map(position: $position) {
            UserAnnotation()
            
          
        }

        .mapControls { MapCompass(); MapScaleView() }
  
        .mapStyle(.standard(elevation: .flat))
        .scrollDisabled(true)
    }
}

#Preview {
    MapView()
}


