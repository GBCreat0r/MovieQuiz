//
//  GameResult.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 20.01.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
        }
}
