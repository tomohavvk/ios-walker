//
//  MinimalistAlertView.swift
//  walker
//
//  Created by IZ on 22.02.2024.
//

import SwiftUI

struct MinimalistAlertView: View {
  @Binding var showAlert: Bool

  var body: some View {

    if showAlert {

      ZStack {
        ZStack {
          Color.clear.edgesIgnoringSafeArea(.all)

          VStack(spacing: 10) {

            Text("This feature is not yet implemented...")
              .foregroundColor(.white)
              .multilineTextAlignment(.center)

            Button("OK") {
              showAlert = false
            }

            //                    .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(5)
            //                    .frame(width: 80, height: 80)
            //                    .foregroundColor(.green)
            //                    .background(Color.green.opacity(0.2))
            //                    .clipShape(Circle())
          }
          .padding()
          .background(Color.black)
          .cornerRadius(10)
          //    .frame(width: 400, height: 200)
        }
      }

    }
  }
}

struct MinimalistAlertView_Previews: PreviewProvider {
  static var previews: some View {
    MinimalistAlertView(showAlert: .constant(true))
  }
}
