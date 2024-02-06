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
            
            HStack {
                Text("GPX Files").font(.title)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                
                Button("Close") {
                    instrumentModel.isGPXFilesSheetPresented.toggle()
                }  .bold().padding()
                  
                
                
            }
            
            Divider()
            
            
            List {
                ForEach(gpxFilesModel.gpxFileNameList, id: \.self) { filename in
                    Text(filename)
                        .font(.title2)
                        .foregroundColor(.white)
                        .listRowBackground(Color.black)
//                    Divider().foregroundStyle(/*@START_MENU_TOKEN@*/SecondaryContentStyle()/*@END_MENU_TOKEN@*/)
                }
                .onDelete(perform: delete)
            }
            .listStyle(.plain)
            
        }.background(.black)
    }
}

#Preview {
    GPXFilesSheetView(instrumentModel: InstrumentModel(recordLocation: true), gpxFilesModel: GPXFilesModel(gpxFileNameList: (1...20).map { String($0)}))
}
