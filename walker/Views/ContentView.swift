import SwiftUI

struct ContentView: View {
    @State private var sheetOffset: CGPoint = .zero
    
    @StateObject var locationService:LocationWatcherService = LocationWatcherService()
    
    @StateObject var mapModel: MapViewModel = MapViewModel()
    @StateObject var navigationModel: NavigationViewModel = NavigationViewModel(followLocation: true, recordLocation: true)
    
    var body: some View {
        ZStack(alignment: .top)  {
            MapView(mapModel: mapModel , locationService: locationService)
                .sheet(isPresented: .constant(true)) {
                    SheetView()
                        .onPreferenceChange(PointPreferenceKey.self, perform: { value in
                            sheetOffset = value ?? CGPoint.zero
                        })
                }
            
            NavigationView(navigationModel: navigationModel)
                .offset(x: 0, y: sheetOffset.y - 120)
        }
        .onAppear { start() }
    }
    
  fileprivate func start() {
        NavigationService(navigationModel: navigationModel, mapModel: mapModel, locationService: locationService)
            .start()
    }
}

#Preview {
    ContentView()
}

