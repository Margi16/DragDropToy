//
//  ToyViewModel.swift
//  DragDropToy
//
//  Created by Margi  Bhatt on 31/07/22.
//

import SwiftUI

class ToyViewModel: ObservableObject {
    // MARK: - Gesture Properties
    @Published var currentToy: Toy?
    @Published var currentPosition = initialPosition
    @Published var highlightedId: Int?
    @Published var draggableToyOpacity: CGFloat = 1.0
    @Published var isGameOver = false
    private(set) var attempts = 0
    
    // MARK: - Coordinates
    private static let initialPosition = CGPoint(
        x: UIScreen.main.bounds.midX,
        y: UIScreen.main.bounds.minY
    )
    private var frames: [Int: CGRect] = [:]
    
    // MARK: - Objects in the screen
    private var toys = Toy.all
    var toyContainers = Toy.all
    
    // MARK: - Game lifecycle
    func confirmWhereToyWasDropped() {
        defer { highlightedId = nil }
        
        guard let highlightedId = highlightedId else {
            resetPosition()
            return
        }
        
        if highlightedId == currentToy?.id {
            setCurrentPositionToHighlightedContainer(WithId: highlightedId)
            generateNextRound()
        } else {
            resetPosition()
        }
        
        attempts += 1
    }
    
    func resetPosition() {
        currentPosition = ToyViewModel.initialPosition
    }
    
    func setCurrentPositionToHighlightedContainer(WithId id: Int) {
        guard let frame = frames[id] else {
            return
        }
        currentPosition = CGPoint(x: frame.midX, y: frame.minY)
        makeToyInvisible()
    }
    
    func makeToyInvisible() {
        draggableToyOpacity = 0
    }
    
    func generateNextRound() {
        setNextToy()

        if currentToy == nil {
            gameOver()
        } else {
            prepareObjects()
        }
    }
    
    func setNextToy() {
        currentToy = toys.popLast()
    }
    
    func gameOver() {
        isGameOver = true
    }
    
    func prepareObjects() {
        shuffleToyContainersWithAnimation()
        resetCurrentToyWithoutAnimation()
    }
    
    func shuffleToyContainersWithAnimation() {
        withAnimation {
            toyContainers.shuffle()
        }
    }
    
    func resetCurrentToyWithoutAnimation() {
        withAnimation(.none) {
            resetPosition()
            restoreOpacityWithAnimation()
        }
    }
    
    func restoreOpacityWithAnimation() {
        withAnimation {
            draggableToyOpacity = 1.0
        }
    }
    
    func generateNewGame() {
        toys = Array(Toy.all.shuffled().prefix(upTo: 1))
        attempts = 0
        generateNextRound()
    }
    
    // MARK: - Updates in the screen
    func update(frame: CGRect, for id: Int) {
        frames[id] = frame
//        print(frames)
    }
    
    func update(dragPosition: CGPoint) {
        currentPosition = dragPosition
        for (id, frame) in frames where frame.contains(dragPosition) {
            highlightedId = id
            return
        }
        
        highlightedId = nil
    }
    
    func isHighlighted(id: Int) -> Bool {
        highlightedId == id
    }
}

