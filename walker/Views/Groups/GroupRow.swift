//
//  GroupRow.swift
//  walker
//
//  Created by IZ on 21.02.2024.
//

import SwiftUI

struct GroupRow: View {
  @Binding var detent: PresentationDetent
  @State var group: GroupDTO

  var body: some View {
    NavigationLink(
      destination:
        GroupInsideView(detent: $detent, group: group)
        .background(.black)
        .scrollContentBackground(.hidden)
    ) {
      HStack {
        ZStack {
          Image(systemName: "person.3")
            .foregroundColor( /*@START_MENU_TOKEN@*/.blue /*@END_MENU_TOKEN@*/)
            .font(.system(size: 20))
            //  .resizable()
            .scaledToFill()
            .frame(width: 60, height: 60)
            .cornerRadius(10)

          ZStack(alignment: .center) {
            Circle()
              .frame(width: 20, height: 20)
              .foregroundStyle(
                .linearGradient(
                  colors: [.purple, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
              )
              .shadow(color: Color.black.opacity(0.3), radius: 3, x: 1, y: 2)

            Text("\(group.deviceCount)")
              .bold()
              .foregroundColor(.white)

          }
          .offset(x: 25, y: 25)
        }

        VStack(alignment: .leading) {
          Text(group.name)
            .font(.system(size: 20, weight: .medium, design: .rounded))

          Text(group.name)
            .font(.system(size: 10, weight: .medium, design: .rounded))

        }
      }

      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  GroupRow(detent: .constant(.large), group: groupsTesting[0])
}
