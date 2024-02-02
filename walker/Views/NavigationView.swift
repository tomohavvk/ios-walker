//
//  NavigationGroupView.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import SwiftUI

struct NavigationView: View {
    @ObservedObject var navigationModel: NavigationViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action:  {navigationModel.recordLocation = !navigationModel.recordLocation}) {
                Image(systemName: navigationModel.recordLocation ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    NavigationView(navigationModel: NavigationViewModel(recordLocation: true))
}
