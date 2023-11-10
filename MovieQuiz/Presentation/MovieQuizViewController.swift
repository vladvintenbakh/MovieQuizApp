import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    private let questionCount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var alertPresenter: AlertPresenterProtocol? = AlertPresenter()
    
    private var statsService: StatsServiceProtocol = StatsServiceImplementation()
    
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: MovieLoader(),
                                          delegate: self)
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quizStep: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(data: model.image) ?? UIImage()
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
        showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBAction private func noButtonPressed(_ sender: Any) {
        guard let currentQuestion else { return }
        let isCorrect = currentQuestion.correctAnswer == false
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
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(
            title: "Error",
            message: message,
            buttonText: "Try again")
        
        show(quizResult: alert)
    }
}
