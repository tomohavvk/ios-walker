//
//  GroupListView.swift
//  walker
//
//  Created by IZ on 14.02.2024.
//

import SwiftUI

struct GroupsListView: View {
  @Binding var detent: PresentationDetent
  var groupsToShow: [GroupDTO]

  var body: some View {
    List {
      ForEach(groupsToShow) { group in
        GroupRow(detent: $detent, group: group)
          .listRowBackground(Color.black)

      }

    }

  }
}

struct GroupsList_Previews: PreviewProvider {
  static var previews: some View {
    GroupsListView(
      detent: .constant(.large), groupsToShow: groupsTesting.sorted { $0.name < $1.name })
  }
}
