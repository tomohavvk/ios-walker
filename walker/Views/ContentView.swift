import SwiftUI
import CoreData

struct ContentView: View {
    private let minHeight: CGFloat = 140
    private let snapThreshold: CGFloat = 200
    
    @State private var topViewHeight: CGFloat = 480
    
    private let screenWidth  = UIScreen.main.bounds.width
    private static let walkerClient  =   WalkerClient(baseURL: "", deviceId: UIDevice.current.identifierForVendor!.uuidString)
    
    @State private var sheetOffset: CGPoint = .zero
    
    
    @StateObject private var polylineHelper: PolylineHelper
    @StateObject private var locationService: LocationWatcherService
    
    @ObservedObject private var locationWatcherModel: LocationWatcherModel
    
    
    init(locationWatcherModel: LocationWatcherModel) {
        self.locationWatcherModel = locationWatcherModel
        self._polylineHelper =  StateObject(wrappedValue: PolylineHelper( locationWatcherModel: locationWatcherModel))
        self._locationService =  StateObject(wrappedValue: LocationWatcherService(model: locationWatcherModel))
        
    }
    
    
    @State private var searchText = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack  {
                NewView(polylineHelper: polylineHelper)

                    .edgesIgnoringSafeArea(.all)
                
                Spacer()
                    .sheet(isPresented: .constant(true), content: {
                        ScrollView()  {
                            Grid {
                                GridRow {
                                    Image(systemName: "person")
                                    Text("Groups").fontWeight(.bold)
                                    Image(systemName: "trash")
                                        .frame(width: 32, height: 32)
                                        .background(Color.blue)
                                        .mask(Circle())
                                }.foregroundColor(.black)
                                Divider()
                            }.padding()
                        }
       
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.mint, .blue]), startPoint: .top, endPoint: .bottom)
                        )
                        .scrollDisabled(true)
                        .interactiveDismissDisabled(true)
                        .presentationDetents([.fraction(CGFloat(0.2)),.fraction(CGFloat(0.5)),.fraction(CGFloat(0.95))])
                        .presentationBackgroundInteraction(.enabled )
                        .presentationCompactAdaptation(.none)
                      
                        .overlay(alignment: Alignment.bottom) {
                                    
                                             
                                               FooterView( )
                                           }
                                           
                            
                      
                     
                      
                        
                    })
                   
                    .onAppear { start() }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.mint, .blue]), startPoint: .top, endPoint: .bottom)
            )
        }
    }
    
    
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
    ContentView( locationWatcherModel: LocationWatcherModel() )
}

