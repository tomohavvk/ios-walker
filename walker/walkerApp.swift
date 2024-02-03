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

    @StateObject private var recordingModel: RecordingModel = RecordingModel(recordLocation: true)
    @StateObject private var locationWatcherModel: LocationWatcherModel = LocationWatcherModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView( recordingModel: recordingModel, locationWatcherModel: locationWatcherModel)
        }
    }
}

