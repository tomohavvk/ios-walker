//
//  NavigationGroupView.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import SwiftUI

struct NavigationGroupView: View {
    @ObservedObject var navigationModel: NavigationViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                
            }) {
                Image(systemName: "minus.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            
            Button(action: {
                
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            
            Button(action: {navigationModel.followLocation = !navigationModel.followLocation}) {
                Image(systemName: "location.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            
            Button(action:  {navigationModel.recordLocation = !navigationModel.recordLocation}) {
                Image(systemName: navigationModel.recordLocation ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    NavigationGroupView(navigationModel: NavigationViewModel(followLocation: true, recordLocation: true))
}