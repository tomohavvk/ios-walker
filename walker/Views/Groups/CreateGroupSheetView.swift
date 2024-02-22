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

  @State private var isPublic: Bool = true

  @State private var publicId: String = ""
  @State private var description: String = ""
  @State private var showAlert = false

  @State private var isNameValid: Bool = false
  @State private var isPublicIdValid: Bool = true
  @State private var isTriedToCreate: Bool = false

  var body: some View {
    ZStack {
      if showAlert {
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

        Form(content: {

          Section(
            content: {
              TextField("Group Name", text: $name)
                .validateMinLength(value: $name, isValid: $isNameValid, minLength: 1)
                .limitInputLength(value: $name, length: 128)

              TextField("Description", text: $description)
                .limitInputLength(value: $description, length: 256)
            },
            header: {

              if (isTriedToCreate && name.count == 0) || (name.count != 0 && !isNameValid) {
                HStack {
                  Spacer()
                  Text("Group name must have at least 1 character")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.red)
                  Spacer()
                }
              }
            }, footer: {}
          )

          if isPublic {
            Section(
              content: {
                HStack(spacing: 1) {
                  Text("walker.com/")
                    .foregroundColor(.gray)

                  TextField("id", text: $publicId)

                    .validateMinLength(value: $publicId, isValid: $isPublicIdValid, minLength: 5)
                    .limitInputSpacing(value: $publicId)
                    .limitInputLength(value: $publicId, length: 32)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                }
              }, header: {},
              footer: {
                if (isTriedToCreate && publicId.count == 0)
                  || (publicId.count != 0 && !isPublicIdValid)
                {
                  Text("Public id must have at least 5 characters")
                    .foregroundColor(.red)
                }
              })

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

        })
      }
      .background(.black)
      .scrollContentBackground(.hidden)
    }
  }

  private func createGroup() {

    if isPublicIdValid && isNameValid {

      walkerApp.wsMessageSender.createGroup(
        id: NanoID.new(21),
        name: name,
        isPublic: isPublic,
        publicId: isPublic ? publicId : nil,
        description: description)
      showingCreateGroupSheet = false

    } else {
      isTriedToCreate = true
    }
  }
}

struct TextFieldMinLengthValidationModifer: ViewModifier {
  @Binding var value: String
  @Binding var isValid: Bool
  var minLength: Int
  func body(content: Content) -> some View {
    content
      .onReceive(value.publisher.collect()) {

        if String($0).count < minLength {
          isValid = false
        } else {
          isValid = true
        }
      }
  }
}

struct TextFieldLimitModifer: ViewModifier {
  @Binding var value: String
  var length: Int
  func body(content: Content) -> some View {
    content
      .onReceive(value.publisher.collect()) {
        value = String($0.prefix(length))
      }
  }
}

struct TextFieldLimitSpacingModifer: ViewModifier {
  @Binding var value: String

  func body(content: Content) -> some View {
    content
      .onReceive(value.publisher.collect()) {
        value = String($0).trimmingCharacters(in: .whitespaces)
      }
  }
}

extension View {
  func validateMinLength(value: Binding<String>, isValid: Binding<Bool>, minLength: Int)
    -> some View
  {
    self.modifier(
      TextFieldMinLengthValidationModifer(value: value, isValid: isValid, minLength: minLength))
  }

  func limitInputLength(value: Binding<String>, length: Int) -> some View {
    self.modifier(TextFieldLimitModifer(value: value, length: length))
  }
  func limitInputSpacing(value: Binding<String>) -> some View {
    self.modifier(TextFieldLimitSpacingModifer(value: value))
  }
}

#Preview {
  CreateGroupSheetView(showingCreateGroupSheet: .constant(true), nanoid: NanoID.new(21))
}
