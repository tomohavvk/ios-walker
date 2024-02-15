//
//  GroupListView.swift
//  walker
//
//  Created by IZ on 14.02.2024.
//

import SwiftUI

struct GroupsListView: View {
    var groupsToShow :[Group]

    init(groupsToShow: [Group]) {
        self.groupsToShow = groupsToShow
    }
    
    var body: some View {
        List {
            ForEach(groupsToShow) { contact in
                NavigationLink(destination:
                                ContactView(contact: contact)
                ) {
                    HStack {
                        ZStack {
                            Image("logan")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .cornerRadius(10)
                            ZStack(alignment: .center) {
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(
                                        .linearGradient(colors: [.purple, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 1, y: 2)
                                
                                Text("\(contact.rank)")
                                    .bold()
                                    .foregroundColor(.white)
                                    
                            }
                            .offset(x: 25, y: 25)
                        }
                        Text(contact.name)
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                    }
                }
            }
        }
    }
}

struct GroupsList_Previews: PreviewProvider {
    static var previews: some View {
        GroupsListView(groupsToShow: groupsTesting.sorted { $0.name < $1.name })
    }
}

enum ContactSortingMethod: String, Decodable {
    case alphabetical = "Abc"
    case rank = "Rank"
    case recent = "Recent"
}
