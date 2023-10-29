import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    private let questionCount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol? = QuestionFactory()
    
    private var alertPresenter: AlertPresenterProtocol? = AlertPresenter()
    
    private var statsService: StatsServiceProtocol = StatsServiceImplementation()
    
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        statsService.totalAccuracy = 0
//        statsService.bestGame = GameRecord(correct: 0, total: 0, date: Date())
//        statsService.gamesCount = 0
        
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
    
    private func show(quizResult: AlertModel) {
        alertPresenter?.delegate = self
        alertPresenter?.displayAlert(alertContent: quizResult)
    }
    
    func didShowAlert() {
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        
        questionFactory?.requestNextQuestion()
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
            var text = ""
            
            let currentResult = correctAnswers == questionCount ?
            "Good job, you answered all \(questionCount) questions correctly!" :
            "Your result: \(correctAnswers)/\(questionCount)"
            text += currentResult
            
            statsService.gamesCount += 1
            let quizzesPlayed = "\nNumber of quizzes played: \(statsService.gamesCount)"
            text += quizzesPlayed
            
            statsService.store(correct: correctAnswers, total: questionCount)
            let highScore = "\nHigh score: \(statsService.bestGame.correct)/\(statsService.bestGame.total) (\(Date().dateTimeString))"
            text += highScore
            
            statsService.recalculateAccuracy(correct: correctAnswers, total: questionCount)
            let accuracy = String(format: "%.2f", statsService.totalAccuracy)
            let averageAccuracy = "\nAverage accuracy: \(accuracy)%"
            text += averageAccuracy
            
            let quizResult = AlertModel(
                title: "Quiz round completed",
                message: text,
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
