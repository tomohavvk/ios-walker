import SwiftUI

struct FooterView: View {

  var body: some View {

    HStack {
      Spacer()
      Button(action: {

      }) {

        Image(systemName: "gear").foregroundColor(.white)

      }
      .padding()

      Spacer()

      Button(action: {

      }) {
        Image(systemName: "person").foregroundColor(.white)

      }
      .padding()
      Spacer()
      Button(action: {
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
      Spacer()
    }
  }
}

#Preview {
  FooterView()
}
