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
        _ = Injector()
    }
    
    @StateObject private var mapModel: MapViewModel = MapViewModel()
    @StateObject private var navigationModel: NavigationViewModel = NavigationViewModel(recordLocation: true)
    @StateObject private var locationWatcherModel: LocationWatcherModel = LocationWatcherModel()
    
    var body: some Scene {
        
        WindowGroup {
            ContentView(mapModel: mapModel,navigationModel: navigationModel, locationWatcherModel: locationWatcherModel)
        }
    }
}

