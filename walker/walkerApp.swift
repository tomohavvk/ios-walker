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

    @StateObject private var instrumentModel: InstrumentModel = InstrumentModel(recordLocation: true)
    @StateObject private var locationWatcherModel: LocationWatcherModel = LocationWatcherModel()
    @StateObject private var gpxFilesModel: GPXFilesModel = GPXFilesModel(gpxFileNameList: (1...20).map { String($0)})
    @State  var topViewHeight: CGFloat = 480
    var body: some Scene {
       
       
            WindowGroup {
                GeometryReader { geometry in
            ContentView( instrumentModel: instrumentModel, locationWatcherModel: locationWatcherModel, gpxFilesModel: gpxFilesModel)
                        .background(.black)
        }
    }
    }
}

