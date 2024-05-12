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
  @ObservedObject var groupMessagesModel: GroupMessagesModel
  var body: some View {
    List {
      ForEach(groupsToShow) { group in
          GroupRow(detent: $detent, group: group, groupMessagesModel: groupMessagesModel)
          .listRowBackground(Color.black)

      }

    }.listStyle(.inset)

  }
}

struct GroupsList_Previews: PreviewProvider {
  static var previews: some View {
    GroupsListView(
      detent: .constant(.large), groupsToShow: groupsTesting.sorted { $0.name < $1.name },  groupMessagesModel: GroupMessagesModel(messagesToShow: []))
  }
}
