import SwiftUI
import MapKit
import Combine
import CoreLocation

struct MapView: View {
    @ObservedObject var locationManager = BackgroundGeolocation()
    @State private var position: MapCameraPosition = .automatic
    @State private var sheetOffset: CGPoint = .zero
    
    
    private func saveToDatabase(_ value: CLLocation) {
        print("Imitate saving to database: \(value)")
    }

    private func handleLocationChange(_ location: CLLocation) {
        position  =    MapCameraPosition
            .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            ))
        //   .camera(mapCamera(from: location))
        
        //   position.camera?.heading = 10
    }
    
    func mapCamera(from location: CLLocation) -> MapCamera {
        return MapCamera(
            centerCoordinate: location.coordinate,
            distance: 10,
            heading: 0,
            pitch: 0
        )
    }
    
    var body: some View {
        NavigationStack {
        ZStack(alignment: .top)  {
            
            Map(position: $position) {
                UserAnnotation()
            }
            .edgesIgnoringSafeArea(.all)
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            .onAppear() {
                locationManager.startWatcher(distanceFilter: 5)
            }
            .onChange(of: locationManager.currentLocation) {
                withAnimation {
                    if let location = locationManager.currentLocation {
                        handleLocationChange(location)
                    }
                
                }
            }
            .mapStyle(.hybrid(elevation: .flat))
            .sheet(isPresented: .constant(true)) {
                SheetView()
                    .onPreferenceChange(PointPreferenceKey.self, perform: { value in
                                             sheetOffset = value ?? CGPoint.zero
                                             print( sheetOffset)
                                         })
            }
            
            Button(action: {
            }) {
                Text("Your Button Text")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
            }
            
            .offset(x: 0, y: sheetOffset.y - 120)
        }
    }
    }
}


struct SheetView: View {

    public var detents: Set<PresentationDetent>

    init() {
        self.detents = (Array(stride(from: 0.1, through: 0.95, by: 0.1))
            .map { PresentationDetent.fraction(CGFloat($0)) }).toSet()
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Text("Hello")
            }
            .preference(key: PointPreferenceKey.self, value: geometry.frame(in: .global).origin )
            .interactiveDismissDisabled(true)
            .presentationDetents(detents)
            .presentationBackgroundInteraction( .enabled )
        }
        .padding()
    }
}

 

struct PointPreferenceKey: PreferenceKey {
    typealias Value = CGPoint?
    static var defaultValue: Value?
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

extension Array where Element: Hashable {
    func toSet() -> Set<Element> {
        return Set(self)
    }
}

#Preview {
    MapView()
}


