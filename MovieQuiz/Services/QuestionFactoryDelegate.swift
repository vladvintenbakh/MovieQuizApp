//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 17/10/23.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
