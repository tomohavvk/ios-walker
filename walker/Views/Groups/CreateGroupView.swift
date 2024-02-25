//
//  CreateGroupSheetView.swift
//  walker
//
//  Created by IZ on 20.02.2024.
//

import SwiftUI
import Combine

class CreateGroupModel: ObservableObject {
    @Published  var lastPublicIdAvailability: Bool = false

    @Published var isCheckingPubicAvailability = false
    @Published var publicId = ""    //to store real-time value
    @Published var debouncedPublicId = ""        //to store debounced value
        
        init() {
            setupTitleDebounce()
        }
        
        func setupTitleDebounce() {
            debouncedPublicId = self.publicId
            $publicId
                .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
                .assign(to: &$debouncedPublicId)
        }
        
}


struct CreateGroupView: View {
  @ObservedObject var groupSheetModel: GroupSheetModel
  @ObservedObject var createGroupModel: CreateGroupModel
  @Binding var detent: PresentationDetent
  @Binding var showingCreateGroupSheet: Bool
  @State var nanoid: String

  @State private var name: String = ""
  @State private var isPublic: Bool = true

  @State private var description: String = ""
    
    
  @State private var isNameValid: Bool = false
  @State private var isPublicIdValid: Bool = true
  @State private var isTriedToCreate: Bool = false

  @State private var showNotImplementedAlert = false
    @State private var isKeyboardVisible = false
    
  var body: some View {
   
    ZStack {
      if showNotImplementedAlert {
        NotImplementedAlert(showAlert: $showNotImplementedAlert)
          .zIndex(1)
      }
        ScrollViewReader { scrollView in
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
          self.showNotImplementedAlert = true
        }

        Form(content: {

          Section {
              TextField("Group Name", text: $name)
                .validateMinLength(value: $name, isValid: $isNameValid, minLength: 1)
                .limitInputLength(value: $name, length: 128)

              TextField("Description", text: $description)
                .limitInputLength(value: $description, length: 256)
            }
            header: {

              if (isTriedToCreate && name.count == 0) || (name.count != 0 && !isNameValid) {
                HStack {
                  Spacer()
                  Text("Group name should not be empty")
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundColor(.red.opacity(0.8))
                  Spacer()
                }
              }
            }  footer: {}
                .listRowBackground(Color(UIColor.gray).opacity(0.15))

          if isPublic {
            Section {
                HStack(spacing: 1) {
                  Text("walker.com/")
                    .foregroundColor(.gray)

                    TextField("id", text: $createGroupModel.publicId)
                   
                    .validateMinLength(value: $createGroupModel.debouncedPublicId, isValid: $isPublicIdValid, minLength: 5)
                    .limitInputSpacing(value: $createGroupModel.debouncedPublicId)
                    .limitInputLength(value: $createGroupModel.debouncedPublicId, length: 32)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                }
              }
          header: {
                  Text("public link")
              } 
          footer: {
              
              if createGroupModel.isCheckingPubicAvailability {
                  HStack {
                      
       
                  Text("Checking    ")
                       
                  
                  Text("")
                  .background(
                       RoundedRectangle(cornerRadius: 8)
                          .stroke(createGroupModel.isCheckingPubicAvailability ? Color.blue : Color.gray, lineWidth: 2)
                   )
                   .overlay(
                       HStack {
                           Spacer()
                           if createGroupModel.isCheckingPubicAvailability {
                               ProgressView()
                                   .progressViewStyle(CircularProgressViewStyle())
                                   .padding(.trailing, 16)
                           }
                       }
                   )
                  }
              } else if (isTriedToCreate && createGroupModel.debouncedPublicId.count == 0)
                    || (createGroupModel.debouncedPublicId.count != 0 && !isPublicIdValid)
              {
                  
                  Text("Public id must have at least 5 characters")
                      .font(.system(size: 12, weight: .medium, design: .rounded))
                      .foregroundColor(.red.opacity(0.8))
              } else if createGroupModel.lastPublicIdAvailability {
                  withAnimation {
                      Text(createGroupModel.debouncedPublicId + " is available")
                          .font(.system(size: 12, weight: .medium, design: .rounded))
                          .foregroundColor(.green.opacity(0.8))
                  }
              } else if createGroupModel.debouncedPublicId.count != 0 && !createGroupModel.lastPublicIdAvailability {
                  withAnimation {
                      Text(createGroupModel.debouncedPublicId + " is already taken")
                          .font(.system(size: 12, weight: .medium, design: .rounded))
                          .foregroundColor(.red.opacity(0.8))
                  }
              }
              
              EmptyView()
                  .onChange(of: createGroupModel.debouncedPublicId, {
                      if createGroupModel.debouncedPublicId.count >= 5 {
                          withAnimation {
                              //  groupSheetModel.lastPublicIdAvailability = false
                          }
                          // FIXME SEND ONLY AFTER USER STOP TAPYNG
                          createGroupModel.isCheckingPubicAvailability = true
                          walkerApp.wsMessageSender.checkPublicIdAvailability(publicId: createGroupModel.debouncedPublicId)
                      }
                  })
              
          } .listRowBackground(Color(UIColor.gray).opacity(0.15))

          } else {
              Section {
                  HStack(spacing: 1) {
                    Text("walker.com/" + nanoid)
                      .foregroundColor(.gray)
                      .font(.system(size: 15, weight: .medium, design: .rounded))
                    Spacer()
                  }
              } header: {
                  Text("private link")
              } footer: {}
                  .listRowBackground(Color(UIColor.gray).opacity(0.15))
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
            .id(1)
          }.listRowBackground(Color(UIColor.gray).opacity(0.15))

        })
      }
      .background(.black)
     .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { notification in
                                     withAnimation {
                                 
                                         scrollView.scrollTo(1, anchor: .bottom)
                                     }
                                 }

                                 NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { _ in
                                     withAnimation {
                                
                                     }
                                 }
         
            self.detent = .fraction(0.99)
        }
    }
      
       
    }

    .onDisappear {
        // Handle actions when the sheet disappears
        // For example, you might want to reset some state variables
        createGroupModel.publicId = ""
        createGroupModel.debouncedPublicId = ""
        createGroupModel.lastPublicIdAvailability = false
    }
  }

  private func createGroup() {

    if isPublicIdValid && isNameValid {

      walkerApp.wsMessageSender.createGroup(
        id: NanoID.new(21),
        name: name,
        isPublic: isPublic,
        publicId: isPublic ? createGroupModel.debouncedPublicId : nil,
        description: description)
      showingCreateGroupSheet = false

    } else {
      isTriedToCreate = true
    }
  }
    
    
    private func validatePublicId() {
        // Perform your logic here
        if createGroupModel.debouncedPublicId.count >= 5 {
            walkerApp.wsMessageSender.checkPublicIdAvailability(publicId: createGroupModel.debouncedPublicId)
        }
    }
}

class Debouncer: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    private var cancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }

    deinit {
        cancellable?.cancel()
    }

    func debounce(interval: TimeInterval, action: @escaping () -> Void) {
        cancellable = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                action()
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
    CreateGroupView(groupSheetModel: GroupSheetModel(searchingFor: "", groupsToShow: groupsTesting), createGroupModel: CreateGroupModel() ,detent: .constant(.large) ,showingCreateGroupSheet: .constant(true), nanoid: NanoID.new(21))
}
