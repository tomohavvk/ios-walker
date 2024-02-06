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
    
    init(   instrumentModel: InstrumentModel, gpxFilesModel: GPXFilesModel) {
        
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
        GeometryReader { geometry in
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 60, height: 5)
                    //   .scaleEffect(dragState.isDragging ? 0.8 : 1.0)
                        .foregroundColor(.black)
                        .padding(.vertical, 15)
                    
                    Spacer()
                }
                
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
                
            }
        }
    }
    
}

#Preview {
    SheetView(instrumentModel: InstrumentModel(recordLocation: true), gpxFilesModel: GPXFilesModel(gpxFileNameList: ["GPX 1 - 12.02.1988"]))
}
