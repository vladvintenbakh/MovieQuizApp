import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    private let questionCount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol? = QuestionFactory()
    
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory?.delegate = self
        questionFactory?.requestNextQuestion()

//        if let firstQuestion = questionFactory.requestNextQuestion() {
//            currentQuestion = firstQuestion
//            let viewModel = convert(model: firstQuestion)
//            show(quizStep: viewModel)
//        }
        
//        let initialView = convert(model: questions[currentQuestionIndex])
//        show(quizStep: initialView)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quizStep: viewModel)
        }
//        show(quizStep: viewModel)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.image) ?? UIImage()
        let questionNumber = "\(currentQuestionIndex + 1)/\(questionCount)"
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
            
            questionFactory?.requestNextQuestion()
            
//            if let firstQuestion = self.questionFactory.requestNextQuestion() {
//                self.currentQuestion = firstQuestion
//                let viewModel = self.convert(model: firstQuestion)
//                self.show(quizStep: viewModel)
//            }
//            let initialView = self.convert(model: self.questions[self.currentQuestionIndex])
//            self.show(quizStep: initialView)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func yesButtonPressed(_ sender: Any) {
        guard let currentQuestion else { return }
        let isCorrect = currentQuestion.correctAnswer == true
//        let isCorrect = questions[currentQuestionIndex].correctAnswer == true
        showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBAction private func noButtonPressed(_ sender: Any) {
        guard let currentQuestion else { return }
        let isCorrect = currentQuestion.correctAnswer == false
//        let isCorrect = questions[currentQuestionIndex].correctAnswer == false
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
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        if currentQuestionIndex == questionCount - 1 {
            // show the results
            let text = correctAnswers == questionCount ?
            "Good job, you answered all \(questionCount) questions correctly!" :
            "Your result: \(correctAnswers)/\(questionCount)"
            
            let quizResult = QuizResultsViewModel(
                title: "Quiz round completed",
                text: text,
                buttonText: "Play again")
            show(quizResult: quizResult)
        } else {
            // show the next question
            currentQuestionIndex += 1
//            if let nextQuestion = questionFactory.requestNextQuestion() {
//                currentQuestion = nextQuestion
//                let viewModel = convert(model: nextQuestion)
//                show(quizStep: viewModel)
//            }
            questionFactory?.requestNextQuestion()
            
//            let questionView = convert(model: questions[currentQuestionIndex])
//            show(quizStep: questionView)
        }
    }
    
}
