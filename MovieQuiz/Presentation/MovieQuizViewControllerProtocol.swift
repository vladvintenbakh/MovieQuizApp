//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 18/11/23.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quizStep: QuizStepViewModel)
    func show(quizResult: AlertModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func enableButtons()
    func disableButtons()
    func resetImageBorder()
}
