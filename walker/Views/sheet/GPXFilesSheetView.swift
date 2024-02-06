//
//  SheetView.swift
//  walker
//
//  Created by IZ on 26.01.2024.
//

import SwiftUI

struct GPXFilesSheetView: View {
    @ObservedObject private var instrumentModel: InstrumentModel
    @ObservedObject private var gpxFilesModel: GPXFilesModel
    
    
    
    init( instrumentModel: InstrumentModel, gpxFilesModel: GPXFilesModel) {
        self.instrumentModel = instrumentModel
        self.gpxFilesModel = gpxFilesModel
    }
    
    func delete(at offsets: IndexSet) {
        withAnimation {
            gpxFilesModel.gpxFileNameList.remove(atOffsets: offsets)
        }
    }
    
    var body: some View {
        
        VStack {
   
                List {
                    ForEach(gpxFilesModel.gpxFileNameList, id: \.self) { filename in
                        Text(filename)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
            //    .presentationContentInteraction(.scrolls)
            
            
        }.padding()
   
    }
}

#Preview {
    GPXFilesSheetView(instrumentModel: InstrumentModel(recordLocation: true), gpxFilesModel: GPXFilesModel(gpxFileNameList: (1...20).map { String($0)}))
}
