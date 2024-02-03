//
//  NavigationGroupView.swift
//  walker
//
//  Created by IZ on 29.01.2024.
//

import SwiftUI

struct RecordingView: View {
    @ObservedObject var recordingModel: RecordingModel
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action:  {recordingModel.recordLocation = !recordingModel.recordLocation}) {
                Image(systemName: recordingModel.recordLocation ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    RecordingView(recordingModel: RecordingModel(recordLocation: true))
}
