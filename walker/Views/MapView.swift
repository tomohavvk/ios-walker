import SwiftUI
import MapKit
import Combine
import CoreLocation

struct MapView: View {
    @ObservedObject var locationManager = BackgroundGeolocation()
    @State private var position: MapCameraPosition = .automatic
    
    
    private func saveToDatabase(_ value: CLLocation) {
        print("Imitate saving to database: \(value)")
    }

    var body: some View {
        
        NavigationStack {
            
            Map(position: $position) {
                UserAnnotation()
            }
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            .onAppear() {
                locationManager.startWatcher(distanceFilter: 5)
            }
            .onChange(of: locationManager.currentLocation) {
                withAnimation {
                    position = locationManager.currentLocation
                }
            }
            .mapStyle(.hybrid(elevation: .flat))
            .sheet(isPresented: .constant(true)) {
                SheetView(position: position)
            }
        }
    }
}

struct SheetView: View {
    @State public var position: MapCameraPosition
    
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Text("Hello")
            }
            
            .interactiveDismissDisabled(true)
            .presentationDetents([.fraction(0.1),.fraction(0.2),.fraction(0.3),.fraction(0.4),.fraction(0.5),.fraction(0.6),.fraction(0.7), .fraction(0.95)])
            .presentationBackgroundInteraction( .enabled )
        }
        .padding()
    }
}

#Preview {
    MapView()
}


