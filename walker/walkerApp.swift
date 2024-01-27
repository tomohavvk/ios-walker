//
//  walkerApp.swift
//  walker
//
//  Created by IZ on 26.01.2024.
//

import SwiftUI
import UIKit
//@_exported import HotSwiftUI

@main
struct walkerApp: App {
   
    init() {
        Injector()
    }
    
    var body: some Scene {

        WindowGroup {
          
            ContentView()
           //     .eraseToAnyView()
        }
    }
    
    
//#if DEBUG
//   @ObservedObject var iO = injectionObserver
//   #endif
//   // or use the new property wrapper...
//   @ObserveInjection var redraw
}
