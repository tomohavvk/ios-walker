//
//  PersonSheetView.swift
//  walker
//
//  Created by IZ on 14.02.2024.
//

import SwiftUI

struct PersonSheetView: View {
    @State private var searchText = ""
    
    
    var body: some View {
        ScrollView()  {
            VStack {
                Grid {
                    GridRow {
                        VStack(alignment: .leading) {
                            HStack {
                                TextField("Search Group", text: $searchText)
                                    .textFieldStyle(.roundedBorder)
                                    .colorMultiply(.gray.opacity(0.8))
                                Image(systemName: "plus").font(.subheadline).padding()
                            }
                            
                            Divider()
                            Text("Person").fontWeight(.bold)
                        }
                    }
                }.foregroundColor(.black).padding()
                GroupsListView()
                
            }
        }
    }
}

#Preview {
    PersonSheetView()
}
