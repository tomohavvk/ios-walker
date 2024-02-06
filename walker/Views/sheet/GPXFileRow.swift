//
//  GPXFilesView.swift
//  walker
//
//  Created by IZ on 05.02.2024.
//

import SwiftUI

struct GPXFileRow: View {

    var fileName: String
    var onDelete: () -> Void

      var body: some View {
          HStack {
              Text(fileName)
              Spacer()
              Button(action: {
                  onDelete()
              }, label: {
                  Image(systemName: "trash")
                      .foregroundColor(.red)
              })
          
              .buttonStyle(BorderlessButtonStyle())
          }
       
      }
}

#Preview {
    GPXFileRow(fileName: "hello world") {
        
    }
}
