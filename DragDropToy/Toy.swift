//
//  Toy.swift
//  DragDropToy
//
//  Created by Margi  Bhatt on 31/07/22.
//

import SwiftUI

struct Toy {
    let id: Int
    let color: Color
}

extension Toy {
    static let all = [
        Toy(id: 1, color: .gray)
    ]
}
