//
//  walkerApp.swift
//  walker
//
//  Created by IZ on 26.01.2024.
//

import SwiftUI

@main
struct walkerApp: App {
     static let walkerClient  =   WalkerClient(baseURL: "", deviceId: UIDevice.current.identifierForVendor!.uuidString)


    @StateObject private var locationWatcherModel: LocationWatcherModel = LocationWatcherModel()
    @StateObject var navModel: NavigationBarModel = NavigationBarModel(currentTabOpened: "person")
    @StateObject var groupSheetModel: GroupSheetModel = GroupSheetModel(searchingFor: "", groupsToShow: groupsTesting)
    
    @State  var topViewHeight: CGFloat = 480
    
    
    init() {
        _ = Injector()
        print("INIT ROOT")
        

        
       
    }

    
    var body: some Scene {

        
          return  WindowGroup {
                GeometryReader { geometry in
                    ContentView( locationWatcherModel: locationWatcherModel, navModel: navModel, groupSheetModel: groupSheetModel)
                        .background(.black)
                        .task {
                            print("going to make request")
                                 do {
                                     self.groupSheetModel.groupsToShow = try await Self.walkerClient.getDeviceOwnedOrJoinedGroups()
                                 } catch {
                                     // Handle errors here
                                     print("Error: \(error)")
                                 }
                        }
        }
    }
    }
}

