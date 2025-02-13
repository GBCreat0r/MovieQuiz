//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 20.01.2025.
//

import Foundation

protocol StatisticServiceProtocol {
    var gameCount: Int {get}
    var bestGame: GameResult {get}
    var totalAccuracy: Double {get}
    
    func storeAndCreateMassage(gameTry: GameResult) -> String 
}
