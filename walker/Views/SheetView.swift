//
//  SheetView.swift
//  walker
//
//  Created by IZ on 26.01.2024.
//

import SwiftUI

struct SheetView: View {
    @ObservedObject private var recordingModel: RecordingModel
    
    private var detents: Set<PresentationDetent>
    
    init( recordingModel: RecordingModel) {
        self.recordingModel = recordingModel
        self.detents = (Array(stride(from: 0.1, through: 0.95, by: 0.3))
            .map { PresentationDetent.fraction(CGFloat($0)) }).toSet()
    }
    
    var body: some View {
        GeometryReader { geometry in
            Grid {
                GridRow {
                    Image(systemName: "gauge.with.dots.needle.50percent").foregroundColor(.white)
                    Text(String(recordingModel.currentSpeed)).foregroundColor(.white)
                }
                Divider()
                GridRow {
                    Image(systemName: "arrow.triangle.capsulepath").foregroundColor(.white)
                    Text(String(recordingModel.distance)).foregroundColor(.white)
                }
                Divider()
                GridRow {
                    Image(systemName: "arrow.up").foregroundColor(.white)
                    Text(String(recordingModel.currentAltitude)).foregroundColor(.white)
                }
            }
            .interactiveDismissDisabled(true)
            .presentationDetents(detents)
            .presentationBackgroundInteraction(.enabled )
            
            .presentationCompactAdaptation(.none)
        }
        .padding()
    }
}

#Preview {
    SheetView(recordingModel: RecordingModel(recordLocation: true))
}
