//
//  walkerApp.swift
//  walker
//
//  Created by IZ on 26.01.2024.
//

import SwiftUI

@main
struct walkerApp: App {
    
    init() {
        // for hot reloading
        _ = Injector()
    }

    @StateObject private var locationWatcherModel: LocationWatcherModel = LocationWatcherModel()
    @StateObject var footerModel: FooterModel = FooterModel(currentTabOpened: "person")
    
    @State  var topViewHeight: CGFloat = 480
    var body: some Scene {
       
       
            WindowGroup {
                GeometryReader { geometry in
                    ContentView( locationWatcherModel: locationWatcherModel, footerModel: footerModel)
                        .background(.black)
        }
    }
    }
}

