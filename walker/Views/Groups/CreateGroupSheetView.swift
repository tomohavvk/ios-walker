//
//  CreateGroupSheetView.swift
//  walker
//
//  Created by IZ on 20.02.2024.
//

import SwiftUI

struct CreateGroupSheetView: View {
  @Binding var showingCreateGroupSheet: Bool
  @State var nanoid: String
  @State private var name: String = ""
  @State private var isPublic: Bool = false
  @State private var publicId: String = ""
  @State private var description: String = ""
  @State private var showAlert = false

  var body: some View {
    ZStack {
      if self.showAlert {
        MinimalistAlertView(showAlert: $showAlert)
          .zIndex(1)
      }

      VStack {

        HStack {
          Button("Cancel") {
            showingCreateGroupSheet = false
          }
          .padding()
          Spacer()
          Text("New Group").foregroundColor(.white)
          Spacer()
          Button("Create") {
            createGroup()
          }
          .padding()
        }
        Divider()

        VStack {
          Image(systemName: "camera")
            .font(.system(size: 40, weight: .medium, design: .rounded))
            .frame(width: 80, height: 80)
            .foregroundColor(.green)
            .background(Color.green.opacity(0.2))
            .clipShape(Circle())
          Text("Set New Photo")
            .font(.system(size: 15, weight: .medium, design: .rounded))
            .foregroundColor(.green)

        }.onTapGesture {
          self.showAlert = true
        }

        Form {
          TextField("Group Name", text: $name)
            
          TextField("Description", text: $description)

          if isPublic {
            Section {
              HStack(spacing: 1) {
                Text("walker.com/")
                  .foregroundColor(.gray)
                TextField("id", text: $publicId)
                  .autocapitalization(.none)
                  .disableAutocorrection(true)
                Spacer()
              }
            }

          } else {
            Section {
              HStack(spacing: 1) {
                Text("walker.com/" + nanoid)
                  .foregroundColor(.gray)
                  .font(.system(size: 15, weight: .medium, design: .rounded))
                Spacer()
              }
            }

          }

          Section("GROUP TYPE") {
            HStack {
              Image(systemName: "person.3").foregroundColor(.blue)
              if isPublic {

                Toggle("Public", isOn: $isPublic)

              } else {
                Toggle("Private", isOn: $isPublic)
              }
            }

          }

        }
      }
      .background(.black)
      .scrollContentBackground(.hidden)
    }
  }

  private func createGroup() {

    walkerApp.wsMessageSender.createGroup(
      id: NanoID.new(21),
      name: name,
      isPublic: isPublic,
      publicId: isPublic ? publicId : nil,
      description: description)
    showingCreateGroupSheet = false
  }
}

#Preview {
  CreateGroupSheetView(showingCreateGroupSheet: .constant(true), nanoid: NanoID.new(21))
}
