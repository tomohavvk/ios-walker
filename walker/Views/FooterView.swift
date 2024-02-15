//
//  FooterView.swift
//  walker
//
//  Created by IZ on 06.02.2024.
//

import SwiftUI



class FooterModel : ObservableObject {
    @Published var currentTabOpened: String
    
    init(currentTabOpened: String) {
        self.currentTabOpened = currentTabOpened
    }
}
struct FooterView: View {
    
   
    @State var footerModel: FooterModel
    
    
    
    var body: some View {
        
        
        HStack {
            Spacer()
            Button(action: {
                footerModel.currentTabOpened = "person"
            }) {
                Image(systemName: "person.fill").foregroundColor( .white)
                
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                footerModel.currentTabOpened = "person.3"
            }) {
                
                Image(systemName: "person.3.fill").foregroundColor( .white)
                
            }
            .padding()
            Spacer()

        }

        
    }
}

#Preview {
    FooterView(footerModel: FooterModel(currentTabOpened: "person"))
        .background(.black)
}
