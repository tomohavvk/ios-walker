//
//  GroupListView.swift
//  walker
//
//  Created by IZ on 14.02.2024.
//

import SwiftUI

struct GroupsListView: View {

  @Binding var detent: PresentationDetent
//    @State var groupsToShow: [GroupDTO]
  @ObservedObject var groupSheetModel: GroupSheetModel
  @ObservedObject var groupMessagesModel: GroupMessagesModel
  var body: some View {
    List {
//      ForEach(groupsToShow) { group in
//          GroupRow(detent: $detent, group: group, groupMessagesModel: groupMessagesModel)
//          .listRowBackground(Color.black)
//
//      }
        ForEach(groupSheetModel.groupsToShow.sorted(by: { ($0.updatedAtDate ?? Date.distantPast) < ($1.updatedAtDate ?? Date.distantPast) })) { group in
            GroupRow(detent: $detent, group: group, groupMessagesModel: groupMessagesModel)
                .listRowBackground(Color.black)
        }
    }.listStyle(.inset)

  }
}
