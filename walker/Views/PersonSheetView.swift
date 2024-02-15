//
//  PersonSheetView.swift
//  walker
//
//  Created by IZ on 14.02.2024.
//

import SwiftUI


struct PersonSheetView: View {
    @State var searchingFor = ""
    @State var sortByOptions = [ContactSortingMethod.alphabetical.rawValue, ContactSortingMethod.rank.rawValue, ContactSortingMethod.recent.rawValue]
    @State var selectedSortMethod = ContactSortingMethod.alphabetical
    @State var contactsShown = groups.sorted { $0.name < $1.name }
    
    let geo: GeometryProxy
    let navView: NavigationBarView
    init (geo: GeometryProxy, navView: NavigationBarView) {
        self.geo = geo
        self.navView = navView
    }
  
    
    var body: some View {
      
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                GroupsListView()
            
                
                Menu("Sort".uppercased()) {
                    Button("Abc", action: { sortAlphabetically() })
                    Button("Rank", action: { sortByRank() })
                    Button("Recent", action: { sortByRecent() })
                }
                .frame(width: 70, height: 16)
                .padding()
                .foregroundStyle(
                    .linearGradient(colors: [.purple, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .font(.headline)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .offset(x: -20)
                .shadow(color: Color.black.opacity(0.4), radius: 4, x: 2, y: 2)
            }
            
            .navigationBarItems(leading: navView)
        }

    }
    
    var results: [Group] {
        if searchingFor.isEmpty {
            return contactsShown
        } else {
            return contactsShown.filter { $0.name.contains(searchingFor) }
        }
    }
    
    func sortAlphabetically() {
        contactsShown.sort { $0.name < $1.name }
    }
    
    func sortByRank() {
        contactsShown.sort { $0.rank < $1.rank }
    }
    
    func sortByRecent() {
        contactsShown.shuffle()
    }
    }

#Preview {
    GeometryReader { geo in
        PersonSheetView(geo: geo, navView: NavigationBarView(geo: geo, navModel: NavigationBarModel(currentTabOpened: "person")))
    }
  
}
