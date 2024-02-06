import SwiftUI
import CoreData

struct ContentView: View {
    
    private let screenWidth  = UIScreen.main.bounds.width
    
    @State private var sheetOffset: CGPoint = .zero
    
    @StateObject private var polylineHelper: PolylineHelper
    @StateObject private var locationService: LocationWatcherService
    
    @ObservedObject private var instrumentModel: InstrumentModel
    @ObservedObject private var locationWatcherModel: LocationWatcherModel
    @ObservedObject private var gpxFilesModel: GPXFilesModel
    
    init(instrumentModel: InstrumentModel, locationWatcherModel: LocationWatcherModel, gpxFilesModel: GPXFilesModel) {
        self.instrumentModel = instrumentModel
        self.locationWatcherModel = locationWatcherModel
        self.gpxFilesModel = gpxFilesModel
        self._polylineHelper =  StateObject(wrappedValue: PolylineHelper(instrumentModel: instrumentModel, locationWatcherModel: locationWatcherModel))
        self._locationService =  StateObject(wrappedValue: LocationWatcherService(model: locationWatcherModel))
    }
    
    var body: some View {
        
        let topView =  VStack {
            NewView(polylineHelper: polylineHelper)
            
            
            
        }
        let bottomView =
        
        
        SheetView(instrumentModel: instrumentModel, gpxFilesModel: gpxFilesModel)
        

        return  VStack{
            SplitView(topView:  topView, bottomView: bottomView)
            
                .overlay(alignment: Alignment.bottom) {
                    
                    HStack {
                        Button(action: {
                            // Action for the first button (e.g., Settings)
                            print("Settings button tapped")
                        }) {
                            Image(systemName: "gear")
                                .foregroundColor(.white)
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            // Action for the second button (e.g., Profile)
                            print("Profile button tapped")
                        }) {
                            Image(systemName: "person")
                                .foregroundColor(.white)
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            // Action for the third button (e.g., Notifications)
                            print("Notifications button tapped")
                        }) {
                            Image(systemName: "bell")
                                .foregroundColor(.white)
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {

                            print("More button tapped")
                        }) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
//                    .frame()
                    .background(Color.gray)
                    .ignoresSafeArea(.all)
                    .frame(width: .infinity, height: 30)
                    .onAppear { start() }
                }
             
        }
    }
    
    fileprivate func start() {
        LocationRecordingService(instrumentModel: instrumentModel,   locationService: locationService)
            .start()
    }
}

#Preview {
    ContentView( instrumentModel: InstrumentModel(recordLocation: true), locationWatcherModel: LocationWatcherModel(), gpxFilesModel: GPXFilesModel(gpxFileNameList:  (1...20).map { String($0)}))
}

