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

  static let deviceId = UIDevice.current.identifierForVendor!.uuidString
  static let walkerWS = WalkerWS(deviceId: UIDevice.current.identifierForVendor!.uuidString)
    
    @State var topViewHeight: CGFloat = 480
  @StateObject private var locationWatcherModel: LocationWatcherModel = LocationWatcherModel()
  @StateObject var groupSheetModel: GroupSheetModel = GroupSheetModel(searchingFor: "", groupsToShow: [])
    @StateObject var groupMessagesModel: GroupMessagesModel = GroupMessagesModel(messagesToShow: [])
  @StateObject var createGroupModel: CreateGroupModel = CreateGroupModel()


  var body: some Scene {
    return WindowGroup {
      GeometryReader { geometry in
        ContentView(
          locationWatcherModel: locationWatcherModel,
          groupSheetModel: groupSheetModel,
          groupMessagesModel: groupMessagesModel,
          createGroupModel: createGroupModel
        )
        .background(.black)
      }

    }
  }
}
