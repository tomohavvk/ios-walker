import SwiftUI
import CoreData

struct ContentView: View {
    private let minHeight: CGFloat = 140
    private let snapThreshold: CGFloat = 200
    
    @State private var topViewHeight: CGFloat = 480
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
            
            NewView(polylineHelper: polylineHelper)
            
                .overlay(alignment: Alignment.bottom) {
                    VStack {
                        
                        InstrumentView(instrumentModel: instrumentModel)
                        
                        VStack {
                            HStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 60, height: 5)
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 15)
                                
                                Spacer()
                            }
                            SheetView(instrumentModel: instrumentModel)
                            
//                            if instrumentModel.currentTabName != "gear" {
                                withAnimation {
                                    Spacer()
                                        .sheet(isPresented: $instrumentModel.isGPXFilesSheetPresented, onDismiss:  {
//                                            instrumentModel.currentTabName = "gear"
                                        }, content: {
                                            
                                            GPXFilesSheetView(instrumentModel: instrumentModel, gpxFilesModel: GPXFilesModel(gpxFileNameList: (1...20).map { String($0)}))
                                                .background(.black)
                                                .presentationDetents([.fraction(1)])
                                            
                                            .presentationBackgroundInteraction( .enabled )
                                        })
                                }
//                            }
                            
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - topViewHeight - 40)
                        .background(LinearGradient(gradient: Gradient(colors: [.black, .black]), startPoint: .bottom, endPoint: .top))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .gesture(dragGesture())
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .overlay(alignment: Alignment.bottom) {
                    VStack {
                        Divider().colorMultiply(.white)
                        FooterView(instrumentModel: instrumentModel)
                    }
                    
                }
                .onAppear { start() }
                .ignoresSafeArea()
                .background(.black)
            
        }
        
    }
    
    
    private func start() {
        LocationRecordingService(instrumentModel: instrumentModel,   locationService: locationService)
            .start()
    }
    
    private func dragGesture( ) -> some Gesture {
        DragGesture()
            .onChanged { gesture in
                handleDragChanged(gesture )
            }
            .onEnded { _ in
                handleDragEnded( )
            }
    }
    
    private func handleDragChanged(_ gesture: DragGesture.Value ) {
        dragState = .dragging(translation: gesture.translation)
        
        let newHeight = max(minHeight, min(UIScreen.main.bounds.height - minHeight, topViewHeight + gesture.translation.height))
        if newHeight != topViewHeight {
            topViewHeight = newHeight
        }
    }
    
    private func handleDragEnded( ) {
        dragState = .inactive
        withAnimation(.spring()) {
            let newHeight = topViewHeight
            if newHeight < minHeight + snapThreshold {
                topViewHeight = minHeight
            } else if (UIScreen.main.bounds.height - newHeight) < minHeight + snapThreshold {
                topViewHeight = UIScreen.main.bounds.height - minHeight
            }
        }
    }
}

#Preview {
    ContentView( instrumentModel: InstrumentModel(recordLocation: true), locationWatcherModel: LocationWatcherModel(), gpxFilesModel: GPXFilesModel(gpxFileNameList:  (1...20).map { String($0)}))
}

