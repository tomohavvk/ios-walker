import SwiftUI
import CoreData

struct ContentView: View {
    
    private static let walkerClient  =   WalkerClient(baseURL: "", deviceId: UIDevice.current.identifierForVendor!.uuidString)
    @StateObject private var polylineHelper: PolylineHelper
    @StateObject private var locationService: LocationWatcherService
    
    @ObservedObject private var locationWatcherModel: LocationWatcherModel
    @ObservedObject private var navModel: NavigationBarModel
    
    
    @State private var searchText = "dasdas"
    
    
    init(locationWatcherModel: LocationWatcherModel, navModel: NavigationBarModel) {
        print("INITS DAD SA")
        self.locationWatcherModel = locationWatcherModel
        self.navModel = navModel
        
        self._polylineHelper =  StateObject(wrappedValue: PolylineHelper( locationWatcherModel: locationWatcherModel))
        self._locationService =  StateObject(wrappedValue: LocationWatcherService(model: locationWatcherModel))
        
    }
    
    var body: some View {
        GeometryReader { geo in
            
            NewView(polylineHelper: polylineHelper)
            
                .edgesIgnoringSafeArea(.all)
            
            Spacer()
                .sheet(isPresented: .constant(true), content: {
                    NavigationView {
                        
                  
                    ZStack {
                        if navModel.currentTabOpened == "person" {
                            withAnimation {
                                GroupsSheetView(geo: geo, navView: NavigationBarView(geo: geo, navModel: navModel))
                            }

                        } else {
                            withAnimation {
                  
                                    PersonSheetView(geo: geo, navView: NavigationBarView(geo: geo, navModel: navModel))
                
                                 
                            }
                        }
                    }
                    }
                 
                    .interactiveDismissDisabled(true)
                    .presentationDetents([.fraction(CGFloat(0.4)),.fraction(CGFloat(0.5)),.fraction(CGFloat(0.99))])
                    .presentationBackgroundInteraction(.enabled )
                    .presentationCompactAdaptation(.none)
                })
            
                .onAppear { start() }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.mint, .blue]), startPoint: .top, endPoint: .bottom)
        )
        
    }
    func sendMessage() { }
    
    private func start() {
        locationService.startWatcher()
        LocationRecordingService( locationService: locationService, walkerClient: Self.walkerClient)
            .start()
    }
    
}


extension Array where Element: Hashable {
    func toSet() -> Set<Element> { return Set(self) }
}


#Preview {
    ContentView( locationWatcherModel: LocationWatcherModel(), navModel: NavigationBarModel(currentTabOpened: "person") )
}

