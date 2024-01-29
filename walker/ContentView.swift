import SwiftUI

struct ContentView: View {
    @State private var sheetOffset: CGPoint = .zero
    
    @StateObject var navigationModel: NavigationViewModel = NavigationViewModel(followLocation: true, recordLocation: true)
    @StateObject var mapModel: MapViewModel = MapViewModel()
    @StateObject var locationService:LocationWatcherService = LocationWatcherService()
    
    var body: some View {
        ZStack(alignment: .top)  {
            MapView(mapModel: mapModel , locationService: locationService)
                .sheet(isPresented: .constant(true)) {
                    SheetView()
                        .onPreferenceChange(PointPreferenceKey.self, perform: { value in
                            sheetOffset = value ?? CGPoint.zero
                        })
                }
            
            NavigationGroupView(navigationModel: navigationModel)
                .offset(x: 0, y: sheetOffset.y - 120)
        }
        .onAppear {
            NavigationService(navigationModel: navigationModel, mapModel: mapModel, locationService: locationService)
                .start()
        }
    }
}

#Preview {
    ContentView()
}

