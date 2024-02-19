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
  
    

    
    init(searchingFor: String,  groupsToShow: [Group]) {
        self.searchingFor = searchingFor
        self.groupsToShow = groupsToShow
     
//        var lastFilterValue  =  "init"
//        private var cancellables: Set<AnyCancellable> = []
//        self.$searchingFor
//            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
//            .sink { [] filter in
//                print("groupSheetModel.searchingFor", filter)
//                if self.lastFilterValue != filter {
//                Task {
//                    do {
//                        
//                     
//                        self.lastFilterValue = filter
//                            print("$searchingFor.GET DATA FROM SERVER", filter)
//            
//                           let groups = try await walkerApp.walkerClient.getDeviceOwnedOrJoinedGroups()
//                        
//                        DispatchQueue.main.async {
//                            self.groupsToShow = groups
//                            if  !self.searchingFor.isEmpty {
//                                self.groupsToShow = self.groupsToShow.filter { $0.name.contains(filter) }
//                            }
//                            
//                            return
//                        }
//                    } catch {
//                        // Handle errors here
//                        print("Error: \(error)")
//                    }
//                }
//                }
//                
//            } .store(in: &cancellables)
    }
    
}


struct GroupsSheetView: View {
    
    private let geo: GeometryProxy
    private  let leadingNavView: LeadingNavigationBarView
    private  let trailingNavView: TrailingNavigationBarView
    @ObservedObject  var groupSheetModel: GroupSheetModel
    
    
    init ( geo: GeometryProxy, leadingNavView: LeadingNavigationBarView, trailingNavView: TrailingNavigationBarView, groupSheetModel: GroupSheetModel) {
        
        self.geo = geo
        self.leadingNavView = leadingNavView
        self.trailingNavView = trailingNavView
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
              
            
                .navigationBarItems(leading: leadingNavView, trailing: trailingNavView)
        }
      
     
        .navigationViewStyle(.stack)
    }
    
    
    
}

#Preview {
    GeometryReader { geo in
        GroupsSheetView(geo: geo, leadingNavView: LeadingNavigationBarView(geo: geo, navModel: NavigationBarModel(currentTabOpened: "person")), trailingNavView: TrailingNavigationBarView(geo: geo, navModel: NavigationBarModel(currentTabOpened: "person")),
                        
                        groupSheetModel: GroupSheetModel(searchingFor: "", groupsToShow: groupsTesting)
                        
        )
    }
    
}
