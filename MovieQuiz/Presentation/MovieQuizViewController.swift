import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
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
    
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    private struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }
    
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialView = convert(model: questions[currentQuestionIndex])
        show(quizStep: initialView)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.image) ?? UIImage()
        let questionNumber = "\(currentQuestionIndex + 1)/\(questions.count)"
        return QuizStepViewModel(image: image,
                                 question: model.text,
                                 questionNumber: questionNumber)
    }
    
    private func show(quizStep: QuizStepViewModel) {
        imageView.image = quizStep.image
        textLabel.text = quizStep.question
        counterLabel.text = quizStep.questionNumber
    }
    
    private func show(quizResult: QuizResultsViewModel) {
        
        let alert = UIAlertController(
            title: quizResult.title,
            message: quizResult.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: quizResult.buttonText, style: .default) { [weak self] _ in
            // reset the quiz and show the first question
            guard let self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let initialView = self.convert(model: self.questions[self.currentQuestionIndex])
            self.show(quizStep: initialView)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func yesButtonPressed(_ sender: Any) {
        let isCorrect = questions[currentQuestionIndex].correctAnswer == true
        showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBAction private func noButtonPressed(_ sender: Any) {
        let isCorrect = questions[currentQuestionIndex].correctAnswer == false
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            self.correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            // reset the border
            self.imageView.layer.borderWidth = 0
            // proceed to the next question or results
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        
        self.yesButton.isEnabled = true
        self.noButton.isEnabled = true
        
        if currentQuestionIndex == questions.count - 1 {
            // show the results
            let quizResult = QuizResultsViewModel(
                title: "Quiz round completed",
                text: "Your result: \(self.correctAnswers)/10",
                buttonText: "Play again")
            show(quizResult: quizResult)
        } else {
            // show the next question
            currentQuestionIndex += 1
            let questionView = convert(model: questions[currentQuestionIndex])
            show(quizStep: questionView)
        }
    }
    
}
