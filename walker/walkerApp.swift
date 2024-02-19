//
//  walkerApp.swift
//  walker
//
//  Created by IZ on 26.01.2024.
//

import SwiftUI
import Combine
@main
struct walkerApp: App {
    static let wsMessageSender =  WalkerWSMessageSender()

    static let walkerWS = WalkerWS(deviceId: UIDevice.current.identifierForVendor!.uuidString)

    @StateObject private var locationWatcherModel: LocationWatcherModel = LocationWatcherModel()
    @StateObject var navModel: NavigationBarModel = NavigationBarModel(currentTabOpened: "person")
    @StateObject var groupSheetModel: GroupSheetModel = GroupSheetModel(searchingFor: "", groupsToShow: [])
//    @StateObject  var wsMessageHandler: WalkerWSMessageHandler
    
     private var cancellables: Set<AnyCancellable> = []
    
  
//     lazy  var wsMessageSender =
    
    @State  var topViewHeight: CGFloat = 480
    
    
    init() {
        print("INIT walkerApp")
        print(Self.walkerWS)
        _ = Injector()
        
        
////        self._wsMessageHandler = StateObject(wrappedValue: WalkerWSMessageHandler(groupSheetModel: groupSheetModel))
//        
//        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
//              print(Self.wsMessageSender.getGroups(limit: 100, offset: 0))
//            
//            
//           
//          }
//      
//        walkerApp.walkerWS.$messageReceived.sink { message in
//            
//            DispatchQueue.main.async {
//                wsMessageHandler.handleMessage(message)
//            }
//       
//        }.store(in: &cancellables)
//       
    }

    var body: some Scene {
    
   
          return  WindowGroup {
                GeometryReader { geometry in
                    ContentView(locationWatcherModel: locationWatcherModel, navModel: navModel, groupSheetModel: groupSheetModel)
                        .background(.black)
//                        .task {
//                            print("going to make request")
//                                 do {
//                                     self.groupSheetModel.groupsToShow = try await Self.walkerClient.getDeviceOwnedOrJoinedGroups()
//                                 } catch {
//                                     // Handle errors here
//                                     print("Error: \(error)")
//                                 }
//                        }
        }
                .onAppear {
//                    print("ON_APPEAR ROOT")
//                     var cancellables: Set<AnyCancellable> = []
//                    
//                    var wsMessageHandler: WalkerWSMessageHandler = WalkerWSMessageHandler(groupSheetModel: groupSheetModel)
//                  
//                    walkerApp.walkerWS.$messageReceived.sink { message in
//                        
////                        DispatchQueue.main.async {
//                            wsMessageHandler.handleMessage(message)
////                        }
//                   
//                    }.store(in: &cancellables)
//
//                    
//                    DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
//                        Self.wsMessageSender.getGroups(limit: 100, offset: 0)
//                    }
            //        var wsMessageHandler: WalkerWSMessageHandler = WalkerWSMessageHandler(isInit: isInit, groupSheetModel: groupSheetModel)
                }
    }
    }
}

