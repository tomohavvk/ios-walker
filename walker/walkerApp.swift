//
//  walkerApp.swift
//  walker
//
//  Created by IZ on 26.01.2024.
//

import SwiftUI
import UIKit

@main
struct walkerApp: App {
   
    init() {
        Injector()
    }
    
    var body: some Scene {

        WindowGroup {
            ContentView()
        }
    }

}
