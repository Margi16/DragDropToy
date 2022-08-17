//
//  ToyContainer.swift
//  DragDropToy
//
//  Created by Margi  Bhatt on 31/07/22.
//

import SwiftUI

struct ToyContainer: View {
    let toy: Toy
    @ObservedObject var viewModel: ToyViewModel
    private let regularSize: CGFloat = 100
    private let highlightedSize: CGFloat = 130
    
    var body: some View {
        ZStack{
            Circle()
                .fill(toy.color)
                .frame(width: regularSize, height: regularSize)
            if viewModel.isHighlighted(id: toy.id) {
                Circle()
                    .fill(toy.color)
                    .opacity(0.5)
                    .frame(
                        width: highlightedSize,
                        height: highlightedSize
                    )
            }
        }
                    .overlay {
                        GeometryReader { proxy -> Color in
                            viewModel.update(
                                frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height/4, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
                                for: toy.id
                            )
        
                            return Color.clear
                        }
                    }
        .frame(width: highlightedSize, height: highlightedSize)
    }
}

struct ToyContainer_Previews: PreviewProvider {
    static var previews: some View {
        ToyContainer(
            toy: Toy.all.first!,
            viewModel: ToyViewModel()
        )
    }
}
