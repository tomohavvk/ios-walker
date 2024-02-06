//
//  SheetView.swift
//  walker
//
//  Created by IZ on 26.01.2024.
//

import SwiftUI

struct SheetView: View {
    @ObservedObject private var instrumentModel: InstrumentModel
    @ObservedObject private var gpxFilesModel: GPXFilesModel
    
    
    private var detents: Set<PresentationDetent>
    
    init( instrumentModel: InstrumentModel, gpxFilesModel: GPXFilesModel) {
        self.instrumentModel = instrumentModel
        self.gpxFilesModel = gpxFilesModel
        self.detents = (Array(stride(from: 0.1, through: 0.95, by: 0.3))
            .map { PresentationDetent.fraction(CGFloat($0)) }).toSet()
    }
    
    func delete(at offsets: IndexSet) {
        withAnimation {
            gpxFilesModel.gpxFileNameList.remove(atOffsets: offsets)
        }
    }
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            Grid {
                
                Divider()
                GridRow {
                    Image(systemName: "gauge.with.dots.needle.50percent").foregroundColor(.white)
                    Text(String(instrumentModel.currentSpeed)).foregroundColor(.white)
                }
                Divider()
                GridRow {
                    Image(systemName: "arrow.triangle.capsulepath").foregroundColor(.white)
                    Text(String(instrumentModel.distance)).foregroundColor(.white)
                }
                Divider()
                GridRow {
                    Image(systemName: "arrow.up").foregroundColor(.white)
                    Text(String(instrumentModel.currentAltitude)).foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .font(.system(size: 16, weight: .medium
                      , design: .rounded))
    }
}

#Preview {
    SheetView(instrumentModel: InstrumentModel(recordLocation: true), gpxFilesModel: GPXFilesModel(gpxFileNameList: ["GPX 1 - 12.02.1988"]))
}
