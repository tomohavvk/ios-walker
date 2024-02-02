//
//  SheetView.swift
//  walker
//
//  Created by IZ on 26.01.2024.
//

import SwiftUI

struct SheetView: View {
    
    private var detents: Set<PresentationDetent>
    
    init() {
        self.detents = (Array(stride(from: 0.1, through: 0.95, by: 0.3))
            .map { PresentationDetent.fraction(CGFloat($0)) }).toSet()
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Text("Hello from sheet")
            }
            .interactiveDismissDisabled(true)
            .presentationDetents(detents)
            .presentationBackgroundInteraction( .enabled )
        }
        .padding()
    }
}

#Preview {
    SheetView()
}
