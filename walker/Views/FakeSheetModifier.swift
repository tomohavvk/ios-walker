
import SwiftUI

struct FakeSheetModifier<InnerContent: View, OuterContent: View>: ViewModifier {
    @State private var yOffset: CGFloat
    @State private var dragOffset: CGFloat = 0
    private let innerContent: InnerContent
    private let outerContent: OuterContent
    
    var minHeight: CGFloat
    var maxHeight: CGFloat
    @Binding var expanded: Bool
    
    init(minHeight: CGFloat = 200, maxHeight: CGFloat = 500, expanded: Binding<Bool>, outerContent: OuterContent, @ViewBuilder innerContent: () -> InnerContent) {
        self.innerContent = innerContent()
        self.outerContent = outerContent
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self._yOffset = State(initialValue: minHeight * -1)
        self._expanded = expanded
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                outerContent
                
                VStack(spacing: 0) {
                    Color.gray.brightness(0.2)
                        .frame(width: 35, height: 5)
                        .cornerRadius(3).padding()
                    innerContent
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .background(Color.black.brightness(0.11))
                .cornerRadius(10)
            }
            .edgesIgnoringSafeArea(.bottom)
            .offset(x: 0, y: UIScreen.main.bounds.height + yOffset + dragOffset)
            
            .gesture(DragGesture()
                .onChanged({ event in
                    if UIScreen.main.bounds.height + self.yOffset + self.dragOffset <= 40 {
                        self.dragOffset = ((UIScreen.main.bounds.height + self.yOffset - 40) * -1)
                        self.expanded = true
                    } else {
                        self.dragOffset = event.translation.height
                        self.expanded = false
                    }
                })
                    .onEnded({ event in
                        self.yOffset = self.yOffset + self.dragOffset
                        self.dragOffset = 0
                        
                        withAnimation {
                            let height = min(self.maxHeight, UIScreen.main.bounds.height)
                            
                            let topDiff = height + self.yOffset
                            let bottomDiff = self.minHeight + self.yOffset
                            
                            if abs(topDiff) < abs(bottomDiff) {
                                self.yOffset = (height - 50) * -1
                                self.expanded = true
                                
                            } else {
                                self.yOffset = self.minHeight * -1
                            }
                        }
                    })
            )
        }
    }
}


struct Sheet_Previews: PreviewProvider {
    
    @State static var expanded: Bool = true
    
    static var previews: some View {
        let outerContent =  HStack {
            Button(action: {}) {
                Image(systemName: "minus.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            
            Button(action: {}) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        
        Color.white
            .fakeSheet(minHeight: 125,maxHeight:500, expanded: $expanded, outerContent: outerContent) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Hello world")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.all, 40)
                    Spacer()
                }
            }
    }
}

extension View {
    func fakeSheet<InnerContent: View, OuterContent: View>(minHeight: CGFloat, maxHeight: CGFloat, expanded: Binding<Bool>, outerContent: OuterContent, @ViewBuilder innerContent: () -> InnerContent) -> some View {
        self.modifier(FakeSheetModifier(minHeight: minHeight, maxHeight: maxHeight, expanded: expanded, outerContent: outerContent, innerContent: innerContent))
    }
}
