import SwiftUI

struct ContentView: View {
   
    
    @State private var sheetOffset: CGPoint = .zero
    
    @StateObject var locationService:LocationWatcherService = LocationWatcherService()
    
    @StateObject var mapModel: MapViewModel = MapViewModel()
    @StateObject var navigationModel: NavigationViewModel = NavigationViewModel(followLocation: false, recordLocation: false)
    
    var body: some View {
        ZStack(alignment: .top)  {
            MapView(mapModel: mapModel , locationService: locationService)
                .fakeSheet(minHeight: 125, maxHeight: 500, expanded: .constant(true), outerContent: NavigationView(navigationModel: navigationModel)) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Hello")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.all, 40)
                        Spacer()
                    }
                }
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

