//
//  StatsService.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 29/10/23.
//

import Foundation

protocol StatsServiceProtocol {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct: Int, total: Int)
}
