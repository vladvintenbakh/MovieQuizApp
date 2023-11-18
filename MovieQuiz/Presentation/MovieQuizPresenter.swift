//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Vladislav Vintenbakh on 16/11/23.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    let questionCount = 10
    private var currentQuestionIndex = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var correctAnswers = 0
    var questionFactory: QuestionFactoryProtocol?
    private let statsService: StatsServiceProtocol!
    
    init() {
        statsService = StatsServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MovieLoader(), delegate: self)
        questionFactory?.loadData()
        viewController?.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quizStep: viewModel)
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionCount - 1
    }
    
    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
//        questionFactory?.requestNextQuestion()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(data: model.image) ?? UIImage()
        let questionNumber = "\(currentQuestionIndex + 1)/\(questionCount)"
        return QuizStepViewModel(image: image,
                                 question: model.text,
                                 questionNumber: questionNumber)
    }
    
    func yesButtonPressed() {
        didAnswer(isYes: true)
    }
    
    func noButtonPressed() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        let isCorrect = currentQuestion.correctAnswer == isYes
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
    
    func didAnswer(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
    }
    
    func showNextQuestionOrResults() {
        
        viewController?.enableButtons()
        
        if self.isLastQuestion() {
            // show the results
            let text = makeResultsMessage()
            
//            statsService.gamesCount += 1
//            let quizzesPlayed = "\nNumber of quizzes played: \(statsService.gamesCount)"
//            text += quizzesPlayed
//
//            statsService.store(correct: correctAnswers, total: presenter.questionCount)
//            let highScore = "\nHigh score: \(statsService.bestGame.correct)/\(statsService.bestGame.total) (\(Date().dateTimeString))"
//            text += highScore
//
//            statsService.recalculateAccuracy(correct: correctAnswers, total: presenter.questionCount)
//            let accuracy = String(format: "%.2f", statsService.totalAccuracy)
//            let averageAccuracy = "\nAverage accuracy: \(accuracy)%"
//            text += averageAccuracy
            
            let quizResult = AlertModel(
                title: "Quiz round completed",
                message: text,
                buttonText: "Play again")
            viewController?.show(quizResult: quizResult)
        } else {
            // show the next question
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
//            statsService.gamesCount += 1
//            let quizzesPlayed = "\nNumber of quizzes played: \(statsService.gamesCount)"
//            text += quizzesPlayed
//
//            statsService.store(correct: correctAnswers, total: presenter.questionCount)
//            let highScore = "\nHigh score: \(statsService.bestGame.correct)/\(statsService.bestGame.total) (\(Date().dateTimeString))"
//            text += highScore
//
//            statsService.recalculateAccuracy(correct: correctAnswers, total: presenter.questionCount)
//            let accuracy = String(format: "%.2f", statsService.totalAccuracy)
//            let averageAccuracy = "\nAverage accuracy: \(accuracy)%"
//            text += averageAccuracy
    
    func makeResultsMessage() -> String {
        statsService.store(correct: correctAnswers, total: questionCount)

        let bestGame = statsService.bestGame

        let quizzesPlayed = "Number of quizzes played: \(statsService.gamesCount)"
        let currentResult = "Your result: \(correctAnswers)/\(questionCount)"
        var highScore = "High score: \(bestGame.correct)/\(bestGame.total)"
        highScore += " (\(bestGame.date.dateTimeString))"
        let averageAccuracy = "Average accuracy: \(String(format: "%.2f", statsService.totalAccuracy))%"

        let finalMessage = [
            quizzesPlayed, currentResult, highScore, averageAccuracy
        ].joined(separator: "\n")

        return finalMessage
    }
}
