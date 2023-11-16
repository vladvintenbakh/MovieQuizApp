//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 16/11/23.
//

import UIKit

final class MovieQuizPresenter {
    
    let questionCount = 10
    private var currentQuestionIndex = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionCount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(data: model.image) ?? UIImage()
        let questionNumber = "\(currentQuestionIndex + 1)/\(questionCount)"
        return QuizStepViewModel(image: image,
                                 question: model.text,
                                 questionNumber: questionNumber)
    }
    
}
