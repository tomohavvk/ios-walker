//
//  walkerApp.swift
//  walker
//
//  Created by IZ on 26.01.2024.
//

import Combine
import SwiftUI

@main
struct walkerApp: App {
  static let wsMessageSender = WalkerWSMessageSender()

  static let walkerWS = WalkerWS(deviceId: UIDevice.current.identifierForVendor!.uuidString)
  static let eventPublisher: EventPublisher = EventPublisher()

  @StateObject private var locationWatcherModel: LocationWatcherModel = LocationWatcherModel()
  @StateObject var navModel: NavigationBarModel = NavigationBarModel(currentTabOpened: "person")
  @StateObject var groupSheetModel: GroupSheetModel = GroupSheetModel(
    searchingFor: "", groupsToShow: [])

  private var cancellables: Set<AnyCancellable> = []

  @State var topViewHeight: CGFloat = 480

  init() {
    print("INIT walkerApp")
    print(Self.walkerWS)
    print(Self.eventPublisher)
    _ = Injector()

  }

  var body: some Scene {

    return WindowGroup {
      GeometryReader { geometry in
        ContentView(

          locationWatcherModel: locationWatcherModel, navModel: navModel,
          groupSheetModel: groupSheetModel
        )
        .background(.black)
      }

    }
  }
}
