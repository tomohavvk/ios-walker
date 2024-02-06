
import SwiftUI

struct FakeSheetModifier<InnerContent: View, OuterContent: View>: ViewModifier {
    @State private var yOffset: CGFloat
    @State private var dragOffset: CGFloat = 0
    @State private var initHeight: CGFloat
    @State private var minHeight: CGFloat
    @State private var maxHeight: CGFloat
    @State private var width: CGFloat
    @Binding private var expanded: Bool
    
    private let innerContent: InnerContent
    private let outerContent: OuterContent
    
    init(initHeight: CGFloat = 200, minHeight: CGFloat = 200, maxHeight: CGFloat = 500, width: CGFloat, expanded: Binding<Bool>, outerContent: OuterContent, @ViewBuilder innerContent: () -> InnerContent) {
        
        
        
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            self._minHeight = State(initialValue: minHeight * -2)
            self._width = State(initialValue: width / 2)
        } else {
            self._minHeight = State(initialValue: minHeight)
            self._width = State(initialValue: width)
        }
        
        self.innerContent = innerContent()
        self.outerContent = outerContent
        self._initHeight = State(initialValue: initHeight)
        self._maxHeight = State(initialValue: maxHeight)
        
        self._yOffset = State(initialValue: -100)
        self._expanded = expanded
    }
    
    func body(content: Content) -> some View {
      
        print("CONTENT")
     return  ZStack {
            content
           
             VStack {
                outerContent
                
                VStack(spacing: 0) {
//                    Color.gray.brightness(0.2)
//                        .frame(width: 35, height: 5)
//                        .cornerRadius(3).padding()
                    
                    innerContent
                     
                }  .scrollDisabled(false)
      
                     .frame(width: self.width, height: UIScreen.main.bounds.height)
                .background(Color.black.brightness(0.11))
                .cornerRadius(10)
            }
           // .edgesIgnoringSafeArea(.bottom)
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
            .onAppear {
                withAnimation {
              
                self.yOffset = -self.initHeight
                    
                }
            }
        }
    }

}


struct Sheet_Previews: PreviewProvider {
   
    
    @State static var expanded: Bool = true
    
    static var previews: some View {

        
        Spacer()
//            .fakeSheet(initHeight: UIScreen.main.bounds.height - 55, minHeight: 50, maxHeight: UIScreen.main.bounds.height - 5, width:  UIScreen.main.bounds.width, expanded: .constant(true), outerContent:
            .sheet(isPresented: .constant(true), content: {
                
           
                    
    
            
                GPXFilesSheetView(instrumentModel: InstrumentModel(recordLocation: true), gpxFilesModel: GPXFilesModel(gpxFileNameList: (1...20).map { String($0)}))
                    .scrollDisabled(false)
                  
                    //    .frame(width: .infinity, height: .infinity)
                      //              .padding(10) // Adjust the padding as needed
                   // .frame(height: UIScreen.main.bounds.height - 5)
            })
            .presentationDetents( (Array(stride(from: 0.5, through: 0.95, by: 0.95))
                .map { PresentationDetent.fraction(CGFloat($0)) }).toSet())

    }
}

extension View {
    func fakeSheet<InnerContent: View, OuterContent: View>(initHeight: CGFloat,minHeight: CGFloat, maxHeight: CGFloat, width: CGFloat, expanded: Binding<Bool>, outerContent: OuterContent, @ViewBuilder innerContent: () -> InnerContent) -> some View {
        self.modifier(FakeSheetModifier(initHeight: initHeight, minHeight: minHeight, maxHeight: maxHeight,width:width, expanded: expanded, outerContent: outerContent, innerContent: innerContent))
    }
}
