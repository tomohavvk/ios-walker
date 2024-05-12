//
//  ContactView.swift
//  walker
//
//  Created by IZ on 15.02.2024.
//

import Combine
import Foundation
import MapKit
import SwiftUI
import UIKit

class GroupMessagesModel: ObservableObject {

  @Published var messagesToShow: [GroupMessageDTO]
  init( messagesToShow: [GroupMessageDTO]) {

    self.messagesToShow = messagesToShow
  }
}


struct GroupInsideView: View {
  @Binding var detent: PresentationDetent
  @ObservedObject var group: GroupDTO
  @State var newMessage: String = ""
  @ObservedObject var groupMessagesModel: GroupMessagesModel
    
  func sendMessage() {

    if !newMessage.isEmpty {
      createMessage()
//      messages.append(Message(content: newMessage, isCurrentUser: true))
//      messages.append(Message(content: "Reply of " + newMessage, isCurrentUser: false))
      newMessage = ""
    }
  }

    
    private func createMessage() {
        if !newMessage.isEmpty {
        walkerApp.wsMessageSender.createGroupMessage(groupId: group.id, message: newMessage)
    }
        
    }
    private func getMessages() {
      
        walkerApp.wsMessageSender.getGroupMessages(groupId: group.id,  limit: 100, offset: 0)

    }
    
  func joinGroup() {
    walkerApp.wsMessageSender.joinGroup(groupId: group.id)
    group.isJoined = true
  }

  var body: some View {

    return VStack {

      ScrollViewReader { proxy in
        ScrollView {
          VStack {
              ForEach(groupMessagesModel.messagesToShow) { message in
              MessageView(currentMessage: message)
                .id(message)
            }
          }
          .onReceive(Just(groupMessagesModel.messagesToShow)) { _ in
          
            proxy.scrollTo(groupMessagesModel.messagesToShow.last, anchor: .bottom)

          }

          .onAppear {
              groupMessagesModel.messagesToShow = []
              getMessages()
              proxy.scrollTo(groupMessagesModel.messagesToShow.last, anchor: .bottom)
          }
        }

        HStack {
          if group.isJoined {
            TextField("Send a message", text: $newMessage)
              .textFieldStyle(.roundedBorder)
              .cornerRadius(5)
              .padding(.bottom, 50)
              .onTapGesture{
                  print(5)
                  proxy.scrollTo(groupMessagesModel.messagesToShow.last, anchor: .bottom)
              }
            Button(action: sendMessage) {
              Image(systemName: "paperplane")
                    .padding(.bottom, 50)
            }
          } else {
            Button(action: joinGroup) {
              Text("Join")
            }
            .padding(.bottom, 50)
              
          }
        }
        .padding()
      }
    }
    .onAppear {
      walkerApp.eventPublisher.event = "chat opened"

    }.background(.black)
    .scrollContentBackground(.hidden)

  }
}

struct MessageCell: View {
  var contentMessage: String
  var isCurrentUser: Bool

  var body: some View {
    Text(contentMessage)
      .padding(10)
      .foregroundColor(Color.white)
      .background(isCurrentUser ? Color.green : Color(UIColor.systemGray6))
      .cornerRadius(10)
  }
}

struct MessageView: View {
  var currentMessage: GroupMessageDTO

  var body: some View {
    HStack(alignment: .bottom, spacing: 10) {
        if currentMessage.authorDeviceId != walkerApp.deviceId {
        Image(systemName: "person.circle.fill")
          .resizable()
          .frame(width: 40, height: 40, alignment: .center)
          .cornerRadius(20)
      } else {
        Spacer()
      }
      MessageCell(
        contentMessage: currentMessage.message,
        isCurrentUser: currentMessage.authorDeviceId == walkerApp.deviceId)
    }
    .frame(maxWidth: .infinity, alignment: .leading)

    .padding()
  }
}

struct Message: Hashable {
  var id = UUID()
  var content: String
  var isCurrentUser: Bool
}

struct DataSource {

  static let messages = [

    Message(content: "Hi there!", isCurrentUser: true),

    Message(content: "Hello! How can I assist you today?", isCurrentUser: false),
    Message(content: "How are you doing?", isCurrentUser: true),
    Message(
      content:
        "I'm just a computer program, so I don't have feelings, but I'm here and ready to help you with any questions or tasks you have. How can I assist you today?",
      isCurrentUser: false),
    Message(content: "Tell me a joke.", isCurrentUser: true),
    Message(
      content:
        "Certainly! Here's one for you: Why don't scientists trust atoms? Because they make up everything!",
      isCurrentUser: false),
    Message(content: "How far away is the Moon from the Earth?", isCurrentUser: true),
    Message(
      content:
        "The average distance from the Moon to the Earth is about 238,855 miles (384,400 kilometers). This distance can vary slightly because the Moon follows an elliptical orbit around the Earth, but the figure I mentioned is the average distance.",
      isCurrentUser: false),

  ]
}

//#Preview {
//  GroupInsideView(detent: .constant(.large), group: groupsTesting[0])
//}
