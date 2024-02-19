//
//  NavigationBarView.swift
//  walker
//
//  Created by IZ on 15.02.2024.
//

import SwiftUI

class NavigationBarModel: ObservableObject {
  @Published var currentTabOpened: String

  init(currentTabOpened: String) {
    self.currentTabOpened = currentTabOpened
  }
}

struct LeadingNavigationBarView: View {

  let geo: GeometryProxy
  let navModel: NavigationBarModel

  init(geo: GeometryProxy, navModel: NavigationBarModel) {
    self.geo = geo
    self.navModel = navModel
  }

  var body: some View {

    HStack {

      Button(action: {
        navModel.currentTabOpened = "person"
      }) {
        Image(systemName: "person.fill").foregroundColor(.black)

      }
      .padding()

      Button(action: {
        navModel.currentTabOpened = "person.3"
      }) {

        Image(systemName: "location.fill").foregroundColor(.black)

      }
      .padding()

      Spacer()

    }
  }
}

#Preview {
  GeometryReader { geo in
    LeadingNavigationBarView(geo: geo, navModel: NavigationBarModel(currentTabOpened: "person"))
      .background(.white)
  }

}
