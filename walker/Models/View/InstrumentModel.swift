//
//  NavigationViewModel.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import Foundation
import SwiftUI

class InstrumentModel: ObservableObject {
    @Published var recordLocation: Bool
    // TODO MOVE TO SEPARATE MODEL
    @Published var currentTabName = "gear"
    @Published var isGPXFilesSheetPresented = false
    

    @Published var distance: Int64 = 0
    @Published var currentSpeed: Int = 0
    @Published var currentAltitude: Int = 0
    
    init(recordLocation: Bool) {
        self.recordLocation = recordLocation
    }
}
