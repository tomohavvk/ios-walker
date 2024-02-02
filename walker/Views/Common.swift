//
//  Common.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import SwiftUI

extension Array where Element: Hashable {
    func toSet() -> Set<Element> { return Set(self) }
}
