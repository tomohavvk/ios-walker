import SwiftUI
import CoreData

struct ContentView: View {
    
    private static let walkerClient  =   WalkerClient(baseURL: "", deviceId: UIDevice.current.identifierForVendor!.uuidString)
    @StateObject private var polylineHelper: PolylineHelper
    @StateObject private var locationService: LocationWatcherService
    
    @ObservedObject private var locationWatcherModel: LocationWatcherModel
    
    init(locationWatcherModel: LocationWatcherModel) {
        self.locationWatcherModel = locationWatcherModel
        self._polylineHelper =  StateObject(wrappedValue: PolylineHelper( locationWatcherModel: locationWatcherModel))
        self._locationService =  StateObject(wrappedValue: LocationWatcherService(model: locationWatcherModel))
        
    }
    
    
    @State private var searchText = ""
    @State private var gpxFileNameList = (1...20).map { String($0)}
    
    var body: some View {
        GeometryReader { geometry in
            ZStack  {
                NewView(polylineHelper: polylineHelper)
                
                    .edgesIgnoringSafeArea(.all)
                
                Spacer()
                    .sheet(isPresented: .constant(true), content: {
                        ScrollView()  {
                            VStack {
                                Grid {
                                    GridRow {
                                        Image(systemName: "person")
                                        Text("Groups").fontWeight(.bold)
                                        Image(systemName: "trash")
                                            .frame(width: 32, height: 32)
                                            .background(Color.blue)
                                            .mask(Circle())
                                    }
                                    Divider()
                                    
                                    
                                }.foregroundColor(.black).padding()
                                
                                ScrollView()  {
                                    
                                    List {
                                        ForEach(self.gpxFileNameList, id: \.self) { filename in
                                            HStack {
                                                Image(systemName: "person")
                                                Text("Walker group")
                                            }
                                            .font(.title2)
                                            .foregroundColor(.black)
                                            .listRowBackground(Color.clear)
                                        }
                                        .onDelete(perform: delete)
                                        
                                    } .frame( height: UIScreen.main.bounds.height - 300)
                                        .listStyle(.plain)
                                }
                            }
                        }
                        
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.mint, .blue]), startPoint: .top, endPoint: .bottom)
                        )
                        .interactiveDismissDisabled(true)
                        .presentationDetents([.fraction(CGFloat(0.15)),.fraction(CGFloat(0.5)),.fraction(CGFloat(0.95))])
                        .presentationBackgroundInteraction(.enabled )
                        .presentationCompactAdaptation(.none)
                        
                        .overlay(alignment: Alignment.bottom) {
                            FooterView( )
                                .background(.black)
                              
                        }
                        
                    })
                
                    .onAppear { start() }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.mint, .blue]), startPoint: .top, endPoint: .bottom)
            )
        }
    }
    
    func delete(at offsets: IndexSet) {
        withAnimation {
         print("DELETED")
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

