import SwiftUI
import CoreData

struct ContentView: View {
    

    @StateObject private var polylineHelper: PolylineHelper
    @StateObject private var locationService: LocationWatcherService
    
    @ObservedObject private var locationWatcherModel: LocationWatcherModel
    @ObservedObject private var navModel: NavigationBarModel
    @ObservedObject private var groupSheetModel: GroupSheetModel
    
    
    @State private var searchText = "dasdas"
    
    
    init(locationWatcherModel: LocationWatcherModel, navModel: NavigationBarModel, groupSheetModel: GroupSheetModel) {
        print("INIT ContentView")
        self.locationWatcherModel = locationWatcherModel
        self.navModel = navModel
        self.groupSheetModel = groupSheetModel
        
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
                                GroupsSheetView(geo: geo, leadingNavView: LeadingNavigationBarView(geo: geo, navModel: navModel), trailingNavView: TrailingNavigationBarView(geo: geo, navModel: navModel), groupSheetModel: groupSheetModel)
                            } else {
                                PersonSheetView(geo: geo, navView: LeadingNavigationBarView(geo: geo, navModel: navModel))
                            }
                        }
                    } .animation(nil)
                    
                    .interactiveDismissDisabled(true)
                    .presentationDetents([.fraction(CGFloat(0.1)),.fraction(CGFloat(0.4)),.fraction(CGFloat(0.99))], selection: .constant(.fraction(0.4)))

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
        LocationRecordingService( locationService: locationService, walkerClient: walkerApp.walkerClient)
            .start()
    }
    
}


extension Array where Element: Hashable {
    func toSet() -> Set<Element> { return Set(self) }
}


#Preview {
    ContentView( locationWatcherModel: LocationWatcherModel(), navModel: NavigationBarModel(currentTabOpened: "person"),groupSheetModel: GroupSheetModel(searchingFor: "", groupsToShow: groupsTesting) )
}

