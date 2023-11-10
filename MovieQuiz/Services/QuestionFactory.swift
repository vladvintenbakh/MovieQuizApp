//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 15/10/23.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    
    weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
//    private let questions: [QuizQuestion] = [
//        QuizQuestion(image: "The Godfather",
//                     text: "Is the rating of this movie greater than 6?",
//                     correctAnswer: true),
//        QuizQuestion(image: "The Dark Knight",
//                     text: "Is the rating of this movie greater than 6?",
//                     correctAnswer: true),
//        QuizQuestion(image: "Kill Bill",
//                     text: "Is the rating of this movie greater than 6?",
//                     correctAnswer: true),
//        QuizQuestion(image: "The Avengers",
//                     text: "Is the rating of this movie greater than 6?",
//                     correctAnswer: true),
//        QuizQuestion(image: "Deadpool",
//                     text: "Is the rating of this movie greater than 6?",
//                     correctAnswer: true),
//        QuizQuestion(image: "The Green Knight",
//                     text: "Is the rating of this movie greater than 6?",
//                     correctAnswer: true),
//        QuizQuestion(image: "Old",
//                     text: "Is the rating of this movie greater than 6?",
//                     correctAnswer: false),
//        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
//                     text: "Is the rating of this movie greater than 6?",
//                     correctAnswer: false),
//        QuizQuestion(image: "Tesla",
//                     text: "Is the rating of this movie greater than 6?",
//                     correctAnswer: false),
//        QuizQuestion(image: "Vivarium",
//                     text: "Is the rating of this movie greater than 6?",
//                     correctAnswer: false),
//    ]
    
    func requestNextQuestion() {
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let text = "Is the rating of this movie greater than 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
        
//        guard let index = (0..<questions.count).randomElement() else {
//            delegate?.didReceiveNextQuestion(question: nil)
//            return
//        }
//
//        let question = questions[safe: index]
//        delegate?.didReceiveNextQuestion(question: question)
        
    }
}
