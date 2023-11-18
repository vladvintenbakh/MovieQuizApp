import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
//    private var correctAnswers = 0 // moved
    
//    private var questionFactory: QuestionFactoryProtocol? // moved
    
    private var alertPresenter: AlertPresenterProtocol? = AlertPresenter()
    
//    private var statsService: StatsServiceProtocol = StatsServiceImplementation()
    
//    private var currentQuestion: QuizQuestion?
    
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        
//        questionFactory = QuestionFactory(moviesLoader: MovieLoader(),
//                                          delegate: self)
        
        showLoadingIndicator()
//        questionFactory?.loadData()
    }
    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        guard let question else { return }
//
//        currentQuestion = question
//        let viewModel = presenter.convert(model: question)
//        DispatchQueue.main.async { [weak self] in
//            self?.show(quizStep: viewModel)
//        }
//        presenter.didReceiveNextQuestion(question: question)
//    }
    
//    func didLoadDataFromServer() {
//        activityIndicator.isHidden = true
//        questionFactory?.requestNextQuestion()
//    }

//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
//    }
    
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        let image = UIImage(data: model.image) ?? UIImage()
//        let questionNumber = "\(currentQuestionIndex + 1)/\(questionCount)"
//        return QuizStepViewModel(image: image,
//                                 question: model.text,
//                                 questionNumber: questionNumber)
//    }
    
    func show(quizStep: QuizStepViewModel) {
        imageView.image = quizStep.image
        textLabel.text = quizStep.question
        counterLabel.text = quizStep.questionNumber
    }
    
    func show(quizResult: AlertModel) {        
        alertPresenter?.delegate = self
        alertPresenter?.displayAlert(alertContent: quizResult)
    }
    
    func didShowAlert() {
        presenter.restartGame()
//        self.correctAnswers = 0
        
//        questionFactory?.requestNextQuestion()
    }
    
    @IBAction private func yesButtonPressed(_ sender: Any) {
//        guard let currentQuestion else { return }
//        let isCorrect = currentQuestion.correctAnswer == true
//        showAnswerResult(isCorrect: isCorrect)
        presenter.yesButtonPressed()
    }
    
    @IBAction private func noButtonPressed(_ sender: Any) {
//        guard let currentQuestion else { return }
//        let isCorrect = currentQuestion.correctAnswer == false
//        showAnswerResult(isCorrect: isCorrect)
        presenter.noButtonPressed()
    }
    
    func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrectAnswer {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
    }
    
    func resetImageBorder() {
        self.imageView.layer.borderWidth = 0
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(
            title: "Error",
            message: message,
            buttonText: "Try again")
        
        show(quizResult: alert)
    }
}
