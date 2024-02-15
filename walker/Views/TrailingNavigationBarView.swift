//
//  TrailingNavigationBarView.swift
//  walker
//
//  Created by IZ on 15.02.2024.
//

import SwiftUI

struct TrailingNavigationBarView: View {
    
    let geo: GeometryProxy
    let navModel: NavigationBarModel
    
    init (geo: GeometryProxy, navModel: NavigationBarModel) {
        self.geo = geo
        self.navModel = navModel
    }
    
    var body: some View {
      
        HStack {

            Spacer()
            Button(action: {
                navModel.currentTabOpened = "person"
            }) {
                Image(systemName: "location.fill").foregroundColor( .black)
                
            }
            .padding()
            

            
            Button(action: {
                navModel.currentTabOpened = "person.3"
            }) {
                
                Image(systemName: "plus").foregroundColor( .black)
                
            }
            .padding()
            

        }
    }
}

#Preview {
    GeometryReader { geo in
        TrailingNavigationBarView(geo: geo, navModel: NavigationBarModel(currentTabOpened: "person"))
            .background(.white)
    }
  
}
