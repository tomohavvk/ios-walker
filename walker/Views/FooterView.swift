//
//  FooterView.swift
//  walker
//
//  Created by IZ on 06.02.2024.
//

import SwiftUI

struct FooterView: View {
    var body: some View {
        
        HStack {
            Button(action: {
                // Action for the first button (e.g., Settings)
                print("Settings button tapped")
            }) {
                Image(systemName: "gear")
                    .foregroundColor(.white)
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                // Action for the second button (e.g., Profile)
                print("Profile button tapped")
            }) {
                Image(systemName: "person")
                    .foregroundColor(.white)
            }
            .padding()
            Spacer()
            Button(action: {
                // Action for the third button (e.g., Notifications)
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
        }
        .ignoresSafeArea(.all)
        .frame( height: 60)
    }
}

#Preview {
    FooterView()
}
