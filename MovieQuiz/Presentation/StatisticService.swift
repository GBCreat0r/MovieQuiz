//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 20.01.2025.
//

import Foundation
import UIKit

final class StatisticService: StatisticServiceProtocol {
    weak var viewController: UIViewController?
    private let storage: UserDefaults = .standard
    
    
    enum Keys: String {
        case correct = "correct"
        case total = "total"
        case date = "date"
        case gameCount = "gameCount"
        case bestGame = "bestGame"
        case totalAccuracy = "totalAccuracy"
    }
    
    var gameCount: Int {
        get { storage.integer(forKey: Keys.gameCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gameCount.rawValue) }
    }
    var bestGame: GameResult {
        get {
            GameResult(correct:
                        storage.integer(forKey: Keys.correct.rawValue),
                       total: storage.integer(forKey: Keys.total.rawValue),
                       date: storage.object(forKey: Keys.date.rawValue) as? Date ?? Date())
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(Date(), forKey: Keys.date.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get { storage.double(forKey: Keys.totalAccuracy.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalAccuracy.rawValue) }
    }

    func store(gameTry: GameResult) -> String{
        gameCount += 1
        if gameTry.isBetterThan(bestGame) { bestGame = gameTry }
        let avarage = (totalAccuracy * (Double(gameCount) - 1) + (Double(gameTry.correct) * 10)) / Double(gameCount)
        totalAccuracy = avarage
        
        let averageScoreToString = String(format: "%.2f",totalAccuracy)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY hh:mm"
        let formattedDate = dateFormatter.string(from: bestGame.date)
        
        var massage: String
        massage = "Ваш реультат: \(gameTry.correct)/10" +
        "\n Количество сыгранных квизов: \(gameCount)" +
        "\n Рекорд: \(bestGame.correct)/10 (\(formattedDate))" +
        "\n Средняя точность  \(averageScoreToString) %"
        return massage
    }
}


