//
//  NavigationViewModel.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import Foundation

class NavigationViewModel: ObservableObject {
    @Published var followLocation: Bool
    @Published var recordLocation: Bool
    
    init(followLocation: Bool, recordLocation: Bool) {
        self.followLocation = followLocation
        self.recordLocation = recordLocation
    }
}
