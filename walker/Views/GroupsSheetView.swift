//
//  GroupsSheetView.swift
//  walker
//
//  Created by IZ on 14.02.2024.
//

import SwiftUI
import Combine
class GroupSheetModel : ObservableObject {
    @Published var searchingFor: String
    @Published var groupsToShow: [Group]
    var lastFilterValue  =  "init"
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(searchingFor: String,  groupsToShow: [Group]) {
        self.searchingFor = searchingFor
        self.groupsToShow = groupsToShow
     
        
        
        self.$searchingFor
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [] filter in
                print("groupSheetModel.searchingFor", filter)
                
                Task {
                    do {
                        
                        if self.lastFilterValue != filter {
                            self.lastFilterValue = filter
                     
                        
                        self.groupsToShow = try await walkerApp.walkerClient.getDeviceOwnedOrJoinedGroups()
                        if  !self.searchingFor.isEmpty {
                            self.groupsToShow = self.groupsToShow.filter { $0.name.contains(filter) }
                        }
                        }
                    } catch {
                        // Handle errors here
                        print("Error: \(error)")
                    }
                }
                
                
            } .store(in: &cancellables)
    }
    
}


struct GroupsSheetView: View {
    
    private let geo: GeometryProxy
    private  let navView: NavigationBarView
    @ObservedObject  var groupSheetModel: GroupSheetModel
    
    
    init ( geo: GeometryProxy, navView: NavigationBarView, groupSheetModel: GroupSheetModel) {
        
        self.geo = geo
        self.navView = navView
        self.groupSheetModel = groupSheetModel
        
        //        print("groupSheetModel.searchingFor", groupSheetModel.searchingFor)
        //        if groupSheetModel.searchingFor.isEmpty {
        ////
        //            self.results =  groupSheetModel.groupsToShow
        //        } else {
        //            self.results  = groupSheetModel.groupsToShow.filter { $0.name.contains(groupSheetModel.searchingFor) }
        //        }
        
    }
    
    var body: some View {
        NavigationView {
            
            GroupsListView(groupsToShow: groupSheetModel.groupsToShow)
                .searchable(text:  $groupSheetModel.searchingFor)
                .navigationBarTitleDisplayMode(.inline)
            
            
                .navigationBarItems(leading: navView)
        }
        .navigationViewStyle(.stack)
    }
    
    
    
}

#Preview {
    GeometryReader { geo in
        GroupsSheetView(geo: geo, navView: NavigationBarView(geo: geo, navModel: NavigationBarModel(currentTabOpened: "person")),
                        
                        groupSheetModel: GroupSheetModel(searchingFor: "", groupsToShow: groupsTesting)
                        
        )
    }
    
}
