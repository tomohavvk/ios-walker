//
//  Common.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import SwiftUI

struct PointPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint?
    
    static func reduce(value: inout CGPoint?, nextValue: () -> CGPoint?) {
        value = nextValue()
    }
}

extension Array where Element: Hashable {
    func toSet() -> Set<Element> { return Set(self) }
}
