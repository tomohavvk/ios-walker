//
//  CreateGroupSheetView.swift
//  walker
//
//  Created by IZ on 20.02.2024.
//

import SwiftUI

struct CreateGroupSheetView: View {
  @State private var name: String = ""
  @State private var isPublic: Bool = false
  @State private var publicId: String = ""
  @State private var description: String = ""

  var body: some View {
    //          NavigationView {
    Form {
      Section(header: Text("Group Information")) {
        TextField("Name", text: $name)
        Toggle("Public", isOn: $isPublic)

        if isPublic {
          TextField("Public ID", text: $publicId)
        }

        TextField("Description", text: $description)
      }

      Section {
        Button("Create Group") {
          createGroup()
        }
      }
    }
    .navigationTitle("Create Group")
    .background(.black)
    .scrollContentBackground(.hidden)
    //          }
  }

  private func createGroup() {

    walkerApp.wsMessageSender.createGroup(
      id: NanoID.new(21),
      name: name,
      isPublic: isPublic,
      publicId: isPublic ? publicId : nil,
      description: description)

    // Optionally, you can navigate back or perform other actions after group creation
  }

  // Example ViewModel

}

#Preview {
  CreateGroupSheetView()
}
