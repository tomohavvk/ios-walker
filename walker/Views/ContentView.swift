import Combine
import CoreData
import SwiftUI

class EventPublisher: ObservableObject {
  @Published var event: String = "init"
}

struct ContentView: View {

  @State var detent: PresentationDetent = .fraction(0.1)

  @StateObject private var polylineHelper: PolylineHelper
  @StateObject private var locationService: LocationWatcherService
  @StateObject private var wsMessageHandler: WalkerWSMessageHandler

  @ObservedObject private var locationWatcherModel: LocationWatcherModel
  @ObservedObject private var groupSheetModel: GroupSheetModel
  @ObservedObject private var createGroupModel: CreateGroupModel

  init(
    locationWatcherModel: LocationWatcherModel,
    groupSheetModel: GroupSheetModel,
    createGroupModel: CreateGroupModel
  ) {
    //  print("INIT ContentView")
    self.locationWatcherModel = locationWatcherModel
    self.groupSheetModel = groupSheetModel
    self.createGroupModel = createGroupModel

    self._polylineHelper = StateObject(
      wrappedValue: PolylineHelper(locationWatcherModel: locationWatcherModel))
    self._locationService = StateObject(
      wrappedValue: LocationWatcherService(model: locationWatcherModel))
    self._wsMessageHandler = StateObject(
        wrappedValue: WalkerWSMessageHandler(groupSheetModel: groupSheetModel, createGroupModel: createGroupModel))
  }

  var body: some View {

    GeometryReader { geo in

      NewView(polylineHelper: polylineHelper)
        .edgesIgnoringSafeArea(.all)

      Spacer()
        .sheet(
          isPresented: .constant(true)
        ) {

          withAnimation(.none) {
            NavigationView {
              ZStack {
                GroupsSheetView(
                  detent: $detent,
                  geo: geo,
                  groupSheetModel: groupSheetModel,
                  createGroupModel: createGroupModel)

              }
            }
          }
          .interactiveDismissDisabled(true)
          .presentationDetents(
            [.fraction(CGFloat(0.2)), .fraction(CGFloat(0.99))], selection: $detent
          )
          .presentationBackgroundInteraction(.enabled)
          .presentationCompactAdaptation(.automatic)
          .overlay(alignment: Alignment.bottom) {
            FooterView()
              .background(.black)

          }
        }

        .onAppear {
          start()
        }
    }

  }

  private func start() {

    wsMessageHandler.start()

    locationService.startWatcher()
    LocationRecordingService(locationService: locationService)
      .start()

  }

}

extension Array where Element: Hashable {
  func toSet() -> Set<Element> { return Set(self) }
}

#Preview {

  ContentView(
    locationWatcherModel: LocationWatcherModel(),
    groupSheetModel: GroupSheetModel(searchingFor: "", groupsToShow: groupsTesting),createGroupModel: CreateGroupModel())
}
