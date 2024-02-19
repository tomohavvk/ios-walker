//
//  PersonSheetView.swift
//  walker
//
//  Created by IZ on 14.02.2024.
//

import SwiftUI

struct PersonSheetView: View {

  let geo: GeometryProxy
  let navView: LeadingNavigationBarView
  init(geo: GeometryProxy, navView: LeadingNavigationBarView) {
    self.geo = geo
    self.navView = navView
  }

  var body: some View {
    NavigationView {
      ZStack(alignment: .bottomTrailing) {
        GroupsListView(groupsToShow: groupsTesting)
      }

      .navigationBarItems(leading: navView)
    }

  }
}

#Preview {
  GeometryReader { geo in
    PersonSheetView(
      geo: geo,
      navView: LeadingNavigationBarView(
        geo: geo, navModel: NavigationBarModel(currentTabOpened: "person")))
  }

}
