import SwiftUI
import CoreData

struct ContentView: View {
    
    private let screenWidth  = UIScreen.main.bounds.width
    
    @State private var sheetOffset: CGPoint = .zero
    
    @StateObject private var polylineHelper: PolylineHelper
    @StateObject private var locationService: LocationWatcherService
    
    @ObservedObject private var recordingModel: RecordingModel
    @ObservedObject private var locationWatcherModel: LocationWatcherModel
    
    init( recordingModel: RecordingModel, locationWatcherModel: LocationWatcherModel) {
        self.recordingModel = recordingModel
        self.locationWatcherModel = locationWatcherModel
        self._polylineHelper =  StateObject(wrappedValue: PolylineHelper(recordingModel: recordingModel, locationWatcherModel: locationWatcherModel))
        self._locationService =  StateObject(wrappedValue: LocationWatcherService(model: locationWatcherModel))
    }
    
    var body: some View {
        ZStack(alignment: .top)  {
            NewView( polylineHelper: polylineHelper)
                .fakeSheet(minHeight: 125, maxHeight: 500, width: screenWidth,  expanded: .constant(true), outerContent: RecordingView(recordingModel: recordingModel)) {
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
        LocationRecordingService(recordingModel: recordingModel,   locationService: locationService)
            .start()
    }
}

#Preview {
    ContentView( recordingModel: RecordingModel(recordLocation: true), locationWatcherModel: LocationWatcherModel())
}

