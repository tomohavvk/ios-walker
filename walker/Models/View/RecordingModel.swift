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
    
    init(recordLocation: Bool) {
        self.recordLocation = recordLocation
    }

    func handleRecordocationPressed() {
        recordLocation = !recordLocation
    }
}
