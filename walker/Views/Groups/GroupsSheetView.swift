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
  @Published  var lastPublicIdAvailability: Bool = false
  init(searchingFor: String, groupsToShow: [GroupDTO]) {

    self.searchingFor = searchingFor
    self.groupsToShow = groupsToShow
  }

}

struct GroupsSheetView: View {

  @State private var showingCreateGroupSheet = false
  @State private var isPresented = false

  @Binding var detent: PresentationDetent
  let geo: GeometryProxy

  @ObservedObject var groupSheetModel: GroupSheetModel

  var body: some View {
    NavigationView {
      VStack {
        HStack {
          TextField("Search", text: $groupSheetModel.searchingFor)
            .padding()
            .onTapGesture {
              self.detent = .fraction(0.99)
            }

          Button(action: {
            showingCreateGroupSheet.toggle()
          }) {
            Image(systemName: "plus")
              .foregroundColor(.white)
          }
          .padding()
          .sheet(
            isPresented: $showingCreateGroupSheet,
            onDismiss: {
              showingCreateGroupSheet = false
            }
          ) {

              CreateGroupView(groupSheetModel: groupSheetModel, detent: $detent,
              showingCreateGroupSheet: $showingCreateGroupSheet, nanoid: NanoID.new(21))
          }

        }

        GroupsListView(detent: $detent, groupsToShow: groupSheetModel.groupsToShow)
      }
      .background(.black)
      .scrollContentBackground(.hidden)

    }

    .navigationViewStyle(.stack)

  }

}

#Preview {
  GeometryReader { geo in
    GroupsSheetView(
      detent: .constant(.large),
      geo: geo,

      groupSheetModel: GroupSheetModel(searchingFor: "", groupsToShow: groupsTesting)

    )
  }

}
