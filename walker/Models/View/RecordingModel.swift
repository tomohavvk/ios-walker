//
//  NavigationViewModel.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import Foundation
import SwiftUI

class RecordingModel: ObservableObject {
    @Published var recordLocation: Bool
    @Published var distance: Int64 = 0
    @Published var currentSpeed: Int = 0
    @Published var currentAltitude: Int = 0
    
    init(recordLocation: Bool) {
        self.recordLocation = recordLocation
    }

    func handleRecordocationPressed() {
        recordLocation = !recordLocation
    }
}
