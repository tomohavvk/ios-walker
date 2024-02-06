//
//  FooterView.swift
//  walker
//
//  Created by IZ on 06.02.2024.
//

import SwiftUI

struct FooterView: View {
    
    @ObservedObject  var instrumentModel: InstrumentModel
    
    var body: some View {
        
        
        HStack {
            Spacer()
            Button(action: {
                instrumentModel.currentTabName = "gear"
                instrumentModel.isGPXFilesSheetPresented = false
            }) {
                
                Image(systemName: "gear").foregroundColor( instrumentModel.currentTabName == "gear" ? .blue : .white)
                
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                instrumentModel.currentTabName = "person"
                instrumentModel.isGPXFilesSheetPresented = true
            }) {
                Image(systemName: "person").foregroundColor( instrumentModel.currentTabName == "person" ? .blue : .white)
                
            }
            .padding()
            Spacer()
            Button(action: {
                print("Notifications button tapped")
            }) {
                Image(systemName: "bell")
                    .foregroundColor(.white)
            }
            .padding()
            Spacer()
            Button(action: {
                print("More button tapped")
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
            }
            .padding()
            Spacer()
        }
        .background(.black)
        .ignoresSafeArea(.all)
        .frame( height: 60)
    }
}

#Preview {
    FooterView(instrumentModel: InstrumentModel(recordLocation: true))
}
