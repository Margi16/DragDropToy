//
//  DraggableToy.swift
//  DragDropToy
//
//  Created by Margi  Bhatt on 31/07/22.
//

import SwiftUI

struct DraggableToy<Draggable: Gesture>: View {
    let toy: Toy
    let position: CGPoint
    let gesture: Draggable
    private let size: CGFloat = 100
    
    var body: some View {
        Circle()
            .fill(.white)
            .frame(width: size, height: size)
            .shadow(radius: 10)
            .overlay {
                Image("toy").resizable().frame(width: 60, height: 60, alignment: .center)
            }
            .position(position)
            .gesture(gesture)
            
    }
}

struct DraggableToy_Previews: PreviewProvider {
    static var previews: some View {
        DraggableToy(
            toy: Toy.all.first!,
            position: .zero,
            gesture: DragGesture()
        )
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
