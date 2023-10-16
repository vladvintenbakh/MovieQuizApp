//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 16/10/23.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
