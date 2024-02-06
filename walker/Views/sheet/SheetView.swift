//
//  SheetView.swift
//  walker
//
//  Created by IZ on 26.01.2024.
//

import SwiftUI

struct SheetView: View {
    @ObservedObject private var instrumentModel: InstrumentModel
    
    init(   instrumentModel: InstrumentModel ) {
        
        self.instrumentModel = instrumentModel
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
 
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

#Preview {
    SheetView(instrumentModel: InstrumentModel(recordLocation: true) )
}
