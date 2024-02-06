//
//  TestView.swift
//  walker
//
//  Created by IZ on 05.02.2024.
//

import SwiftUI

struct SplitView<TopView: View, BottomView: View>: View {
    private let topView: TopView
    private let bottomView: BottomView
    
    private let minHeight: CGFloat = 100
    private let snapThreshold: CGFloat = 200
    
    @State private var topViewHeight: CGFloat = 480
    @State private var dragState = DragState.inactive
    
    init(topView: TopView, bottomView: BottomView) {
        self.topView = topView
        self.bottomView = bottomView
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center, spacing: 0) {
                topView
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom))
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .ignoresSafeArea(edges: .all)
                
                    .overlay(alignment: Alignment.bottom) {
                        VStack {
                            
                            HStack(spacing: 15) {
                                Button(action:  {}) {
                                    Image(systemName:  "pause.circle.fill"  )
                                        .font(.title)
                                        .foregroundColor(.gray)
                                }
                                .padding(3)
                            }
                            
                            VStack {
                                
                                HStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 60, height: 5)
                                        .scaleEffect(dragState.isDragging ? 0.8 : 1.0)
                                        .foregroundColor(.gray)
                                        .padding(.vertical, 15)
                                    
                                    Spacer()
                                }
                                
                                bottomView
                                    .frame(width: geometry.size.width, height: geometry.size.height - topViewHeight - 30)
                                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            }
                            .background(LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .bottom, endPoint: .top))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        
                        .simultaneousGesture(
                            DragGesture()
                                .onChanged { gesture in
                                    print("GESTURE STARTED")
                                    self.dragState = .dragging(translation: gesture.translation)
                                    
                                    let newHeight = max(minHeight, min(geometry.size.height - minHeight, topViewHeight + gesture.translation.height))
                                    if newHeight != topViewHeight {
                                        //                                        Task {
                                        topViewHeight = newHeight
                                        //                                        }
                                    }
                                }
                                .onEnded { _ in
                                    print("GESTURE ENDED")
                                    self.dragState = .inactive
                                    withAnimation(.spring()) {
                                        let newHeight = topViewHeight
                                        Task {
                                            if newHeight < minHeight + snapThreshold {
                                                topViewHeight = minHeight
                                            } else if (geometry.size.height - newHeight) < minHeight + snapThreshold {
                                                topViewHeight = geometry.size.height - minHeight
                                            }
                                        }
                                    }
                                }
                        )
                    }
                
                
            }
            
        }
        .ignoresSafeArea()
        .background(.black)
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

#Preview {
    VStack {
        
        
        SplitView(topView: Spacer(), bottomView: Spacer())
        
        //    Spacer()
        //
        //               // Footer
        //               Text("This is a footer")
        //                   .padding()
        //                   .background(Color.gray)
    }
}
