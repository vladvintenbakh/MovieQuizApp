//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Vladislav Vintenbakh on 18/11/23.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quizStep: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func show(quizResult: MovieQuiz.AlertModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
    func enableButtons() {
        
    }
    
    func disableButtons() {
        
    }
    
    func resetImageBorder() {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock: MovieQuizViewControllerProtocol = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter()
        sut.viewController = viewControllerMock
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
