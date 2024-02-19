//
//  GroupsSheetView.swift
//  walker
//
//  Created by IZ on 14.02.2024.
//

import Combine
import SwiftUI

class GroupSheetModel: ObservableObject {
  @Published var searchingFor: String
  @Published var groupsToShow: [GroupDTO]

  init(searchingFor: String, groupsToShow: [GroupDTO]) {
    self.searchingFor = searchingFor
    self.groupsToShow = groupsToShow
  }

}

struct GroupsSheetView: View {

  private let geo: GeometryProxy
  private let leadingNavView: LeadingNavigationBarView
  private let trailingNavView: TrailingNavigationBarView
  @ObservedObject var groupSheetModel: GroupSheetModel

  init(
    geo: GeometryProxy, leadingNavView: LeadingNavigationBarView,
    trailingNavView: TrailingNavigationBarView, groupSheetModel: GroupSheetModel
  ) {

    self.geo = geo
    self.leadingNavView = leadingNavView
    self.trailingNavView = trailingNavView
    self.groupSheetModel = groupSheetModel
  }

  var body: some View {
    NavigationView {

      GroupsListView(groupsToShow: groupSheetModel.groupsToShow)
        .searchable(text: $groupSheetModel.searchingFor)

        .navigationBarTitleDisplayMode(.inline)

        .navigationBarItems(leading: leadingNavView, trailing: trailingNavView)
    }

    .navigationViewStyle(.stack)

  }

}

#Preview {
  GeometryReader { geo in
    GroupsSheetView(
      geo: geo,
      leadingNavView: LeadingNavigationBarView(
        geo: geo, navModel: NavigationBarModel(currentTabOpened: "person")),
      trailingNavView: TrailingNavigationBarView(
        geo: geo, navModel: NavigationBarModel(currentTabOpened: "person")),

      groupSheetModel: GroupSheetModel(searchingFor: "", groupsToShow: groupsTesting)

    )
  }

}
