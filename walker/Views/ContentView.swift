import SwiftUI
import CoreData

struct ContentView: View {
    private let minHeight: CGFloat = 100
    private let snapThreshold: CGFloat = 200
    
    @State private var topViewHeight: CGFloat = 510
    @State private var dragState = DragState.inactive
    
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
        GeometryReader { geometry in
        VStack (alignment: .center, spacing: 0) {
            NewView(polylineHelper: polylineHelper)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .ignoresSafeArea(edges: .all)
            .overlay(alignment: Alignment.bottom) {
                VStack {
                    
                    HStack(spacing: 15) {
                        Button(action:  {instrumentModel.recordLocation = !instrumentModel.recordLocation}) {
                            Image(systemName: instrumentModel.recordLocation ? "pause.circle.fill" : "play.circle.fill"  )
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                        .padding(3)
                    }
                    
                    VStack {
                        
                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 60, height: 5)
                                .scaleEffect(dragState.isDragging ? 0.8 : 1.0)
                                .foregroundColor(.gray)
                                .padding(.vertical, 15)
                            
                            Spacer()
                        }
                        
                        SheetView(instrumentModel: instrumentModel, gpxFilesModel: gpxFilesModel)
                            .frame(width: geometry.size.width, height: geometry.size.height - topViewHeight - 30)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
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
                                .background(Color.gray)
                                .ignoresSafeArea(.all)
                                .frame( height: 50)
                                .onAppear { start() }
                            }
                        
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .bottom, endPoint: .top))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { gesture in
                            print("GESTURE STARTED")
                            self.dragState = .dragging(translation: gesture.translation)
                            
                            let newHeight = max(minHeight, min(geometry.size.height - minHeight, topViewHeight + gesture.translation.height))
                            if newHeight != topViewHeight {
                                //                                        Task {
                                topViewHeight = newHeight
                                //                                        }
                            }
                        }
                        .onEnded { _ in
                            print("GESTURE ENDED")
                            self.dragState = .inactive
                            withAnimation(.spring()) {
                                let newHeight = topViewHeight
                                Task {
                                    if newHeight < minHeight + snapThreshold {
                                        topViewHeight = minHeight
                                    } else if (geometry.size.height - newHeight) < minHeight + snapThreshold {
                                        topViewHeight = geometry.size.height - minHeight
                                    }
                                }
                            }
                        }
                )
            }
        }

    }
        .ignoresSafeArea()
        .background(.black)
    }
    
    fileprivate func start() {
        LocationRecordingService(instrumentModel: instrumentModel,   locationService: locationService)
            .start()
    }
}

#Preview {
    ContentView( instrumentModel: InstrumentModel(recordLocation: true), locationWatcherModel: LocationWatcherModel(), gpxFilesModel: GPXFilesModel(gpxFileNameList:  (1...20).map { String($0)}))
}

