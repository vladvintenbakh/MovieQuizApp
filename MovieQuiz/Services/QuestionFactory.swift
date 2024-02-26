//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 15/10/23.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     text: "Is the rating of this movie greater than 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     text: "Is the rating of this movie greater than 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "Is the rating of this movie greater than 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "Is the rating of this movie greater than 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     text: "Is the rating of this movie greater than 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     text: "Is the rating of this movie greater than 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     text: "Is the rating of this movie greater than 6?",
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     text: "Is the rating of this movie greater than 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     text: "Is the rating of this movie greater than 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text: "Is the rating of this movie greater than 6?",
                     correctAnswer: false),
    ]
    
    func requestNextQuestion() {
        
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}
