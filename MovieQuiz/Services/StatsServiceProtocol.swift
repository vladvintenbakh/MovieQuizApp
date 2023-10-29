//
//  StatsService.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 29/10/23.
//

import Foundation

protocol StatsServiceProtocol {
    var totalAccuracy: Double { get set }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get set }
    func store(correct: Int, total: Int)
    func recalculateAccuracy(correct: Int, total: Int)
}
