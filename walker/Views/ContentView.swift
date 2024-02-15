import SwiftUI
import CoreData

struct ContentView: View {
    
    private static let walkerClient  =   WalkerClient(baseURL: "", deviceId: UIDevice.current.identifierForVendor!.uuidString)
    @StateObject private var polylineHelper: PolylineHelper
    @StateObject private var locationService: LocationWatcherService
    
    @ObservedObject private var locationWatcherModel: LocationWatcherModel
    @ObservedObject private var footerModel: FooterModel
    
    
    @State private var searchText = "dasdas"
    
    
    init(locationWatcherModel: LocationWatcherModel, footerModel: FooterModel) {
        print("INITS DAD SA")
        self.locationWatcherModel = locationWatcherModel
        self.footerModel = footerModel
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
                        if footerModel.currentTabOpened == "person" {
                            withAnimation {
                                GroupsSheetView()
                            }

                        } else {
                            withAnimation {
                                NavigationStack {
                                GroupsSheetView()
                            }.searchable(text: $searchText) 
                                 
                            }
                        }
                    }
                    }
                 
                    .interactiveDismissDisabled(true)
                    .presentationDetents([.fraction(CGFloat(0.4)),.fraction(CGFloat(0.5)),.fraction(CGFloat(0.99))])
                    .presentationBackgroundInteraction(.enabled )
                    .presentationCompactAdaptation(.none)
                    .overlay(alignment: Alignment.bottom) {
                        FooterView(footerModel: footerModel )
                            .background(.black)
                        
                    }

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
    ContentView( locationWatcherModel: LocationWatcherModel(), footerModel: FooterModel(currentTabOpened: "person") )
}

