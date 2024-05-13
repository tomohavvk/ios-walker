
import SwiftUI

struct NotImplementedAlert: View {
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
            .foregroundColor(.white)
            .cornerRadius(5)
          }
          .padding()
          .background(Color.black)
          .cornerRadius(10)
        }
      }

    }
  }
}

struct MinimalistAlertView_Previews: PreviewProvider {
  static var previews: some View {
    NotImplementedAlert(showAlert: .constant(true))
  }
}
