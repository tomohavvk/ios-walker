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
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
    }
}

