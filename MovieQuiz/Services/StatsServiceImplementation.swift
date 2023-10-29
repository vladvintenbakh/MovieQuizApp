//
//  StatsServiceImplementation.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 29/10/23.
//

import Foundation

final class StatsServiceImplementation: StatsServiceProtocol {
    
    private enum Keys: String {
        case bestGame, gamesCount, totalAccuracy
    }
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            guard let data = userDefaults.data(forKey: Keys.totalAccuracy.rawValue),
                  let accuracy = try? JSONDecoder().decode(Double.self, from: data) else {
                return 0.0
            }
            return accuracy
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Unable to store the game count")
                return
            }
            userDefaults.set(data, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return count
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Unable to store the game count")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Unable to store the high score")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct: Int, total: Int) {
        let currentGameRecord = GameRecord(correct: correct, total: total, date: Date())
        if currentGameRecord.isBetterThan(bestGame) {
            bestGame = currentGameRecord
        }
    }
    
    func recalculateAccuracy(correct: Int, total: Int) {
        let totalCorrectAnswers = (totalAccuracy / 100) * Double(total) * Double(gamesCount - 1) + Double(correct)
        totalAccuracy = (totalCorrectAnswers / (Double(gamesCount) * Double(total))) * 100
    }
}
