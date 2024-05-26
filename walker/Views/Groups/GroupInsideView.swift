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
    
  init(messagesToShow: [GroupMessageDTO]) {
    self.messagesToShow = messagesToShow
  }
}


struct GroupInsideView: View {
  @State var newMessage: String = ""
  @Binding var detent: PresentationDetent
  @ObservedObject var group: GroupDTO
  @ObservedObject var groupMessagesModel: GroupMessagesModel

     
     let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
     
  func sendMessage() {

    if !newMessage.isEmpty {
        walkerApp.wsMessageSender.createGroupMessage(groupId: group.id, message: newMessage)
        newMessage = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        group.updatedAt = dateFormatter.string(from: Date())
    }
  }

    private func getMessages() {
        walkerApp.wsMessageSender.getGroupMessages(groupId: group.id,  limit: 100, offset: 0)
        walkerApp.wsMessageSender.fetchGroupDevicesLocations(groupId: group.id)
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
              ForEach(groupMessagesModel.messagesToShow.filter { $0.groupId == group.id }) { message in
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
          .onReceive(timer) { _ in
              walkerApp.wsMessageSender.fetchGroupDevicesLocations(groupId: group.id)
            
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
.background(.black)
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
