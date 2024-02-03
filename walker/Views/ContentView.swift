import SwiftUI
import CoreData

struct ContentView: View {
    
    private let screenWidth  = UIScreen.main.bounds.width
    
    @State private var sheetOffset: CGPoint = .zero
    
    @StateObject private var locationService: LocationWatcherService = LocationWatcherService()
    @StateObject private var polylineHelper: PolylineHelper
    
  
    @ObservedObject private var mapModel: MapViewModel
    @ObservedObject private var navigationModel: NavigationViewModel
    
    init(mapModel: MapViewModel, navigationModel: NavigationViewModel) {
        self.mapModel = mapModel
        self.navigationModel = navigationModel
        self._polylineHelper =  StateObject(wrappedValue: PolylineHelper(navigationViewModel: navigationModel))
    }
    
    var body: some View {
        ZStack(alignment: .top)  {
            NewView( locationService: locationService, polylineHelper: polylineHelper)
                .fakeSheet(minHeight: 125, maxHeight: 500, width: screenWidth,  expanded: .constant(true), outerContent: NavigationView(navigationModel: navigationModel)) {
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
    ContentView(mapModel: MapViewModel(), navigationModel: NavigationViewModel(recordLocation: true))
}

