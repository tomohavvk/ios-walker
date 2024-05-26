import Combine
import CoreData
import SwiftUI

struct ContentView: View {

  @State var detent: PresentationDetent = .fraction(0.1)

  @StateObject private var polylineHelper: PolylineHelper
  @StateObject private var locationService: LocationWatcherService
  @StateObject private var wsMessageHandler: WalkerWSMessageHandler

  @ObservedObject private var locationWatcherModel: LocationWatcherModel
  @ObservedObject private var groupSheetModel: GroupSheetModel
  @ObservedObject private var groupMessagesModel: GroupMessagesModel
  @ObservedObject private var createGroupModel: CreateGroupModel

  init(
    locationWatcherModel: LocationWatcherModel,
    groupSheetModel: GroupSheetModel,
    groupMessagesModel: GroupMessagesModel,
    createGroupModel: CreateGroupModel
  ) {
      print("INIT CONTENT VIEW")
    self.locationWatcherModel = locationWatcherModel
    self.groupSheetModel = groupSheetModel
    self.groupMessagesModel = groupMessagesModel
    self.createGroupModel = createGroupModel

    self._polylineHelper = StateObject(
      wrappedValue: PolylineHelper(locationWatcherModel: locationWatcherModel))
    self._locationService = StateObject(
      wrappedValue: LocationWatcherService(model: locationWatcherModel))
    self._wsMessageHandler = StateObject(
      wrappedValue: WalkerWSMessageHandler(
        groupSheetModel: groupSheetModel, groupMessagesModel: groupMessagesModel, createGroupModel: createGroupModel, locationWatcherModel:locationWatcherModel))
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
                  groupMessagesModel: groupMessagesModel,
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
