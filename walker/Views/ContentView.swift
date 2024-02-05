import SwiftUI
import CoreData

struct ContentView: View {
    
    private let screenWidth  = UIScreen.main.bounds.width
    
    @State private var sheetOffset: CGPoint = .zero
    
    @StateObject private var polylineHelper: PolylineHelper
    @StateObject private var locationService: LocationWatcherService
    
    @ObservedObject private var recordingModel: RecordingModel
    @ObservedObject private var locationWatcherModel: LocationWatcherModel
    
    init(recordingModel: RecordingModel, locationWatcherModel: LocationWatcherModel) {
        self.recordingModel = recordingModel
        self.locationWatcherModel = locationWatcherModel
        self._polylineHelper =  StateObject(wrappedValue: PolylineHelper(recordingModel: recordingModel, locationWatcherModel: locationWatcherModel))
        self._locationService =  StateObject(wrappedValue: LocationWatcherService(model: locationWatcherModel))
    }
    
    var body: some View {
        ZStack  {
            NewView( polylineHelper: polylineHelper)
                .fakeSheet(minHeight: 200, maxHeight: 500, width: screenWidth,  expanded: .constant(true), outerContent: RecordingView(recordingModel: recordingModel)) {
                    SheetView(recordingModel: recordingModel)
                }
        }
        
        .onAppear { start() }
    }
    //
    //    var body: some View {
    //        ZStack  {
    //            NewView( polylineHelper: polylineHelper)
    //                .edgesIgnoringSafeArea(.all)
    //
    //            Spacer()
    //                .sheet(isPresented: .constant(true), content: {
    //                    SheetView(recordingModel: recordingModel)
    //                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
    //                        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
    //                            // Update the orientation when it changes
    //                            print( UIDevice.current.orientation.isLandscape)
    //                            print( UIDevice.current.orientation.isPortrait)
    //                            print( UIDevice.current.orientation.isFlat)
    //                            print( UIDevice.current.orientation.isValidInterfaceOrientation)
    //                        }
    //
    //                })
    //        }
    //        .onAppear { start() }
    //    }
    
    fileprivate func start() {
        LocationRecordingService(recordingModel: recordingModel,   locationService: locationService)
            .start()
    }
}

#Preview {
    ContentView( recordingModel: RecordingModel(recordLocation: true), locationWatcherModel: LocationWatcherModel())
}

