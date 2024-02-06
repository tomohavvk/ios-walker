//
//  NavigationGroupView.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import SwiftUI

struct InstrumentView: View {
    @ObservedObject var instrumentModel: InstrumentModel
 
    var body: some View {
        HStack(spacing: 15) {
 
            Button(action:  {instrumentModel.recordLocation = !instrumentModel.recordLocation}) {
                Image(systemName: instrumentModel.recordLocation ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    InstrumentView(instrumentModel: InstrumentModel(recordLocation: true))
}
