import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate{
    // MARK: - Lifecycle
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var counterLabel: UILabel!
    
    lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(viewControler: self)
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var gamesPlayed: Int = 0
    private let questionAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        
        UserDefaults.standard.set(true, forKey: "viewDidLoad") 
        print(Bundle.main.bundlePath)
        print(NSHomeDirectory())
        
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
        
        statisticService = StatisticService()
    }
    
    // MARK:- QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(question: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        enableAndDisableButtonsSwitcher()
        
        guard let  currentQuestion else{return}
        if currentQuestion.correctAnswer == true {
            
            showAnswerResult(isCorrect: true)}
        else{showAnswerResult(isCorrect: false)}
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        enableAndDisableButtonsSwitcher()
        
        guard let currentQuestion else{return}
        if currentQuestion.correctAnswer == false {
            showAnswerResult(isCorrect: true)}
        else{showAnswerResult(isCorrect: false)}
        
    }
    
    
    
    private func convert(question: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(
            image : UIImage(named: question.image) ?? UIImage(),
            question: question.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questionAmount)"
        )
        return quizStepViewModel
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {correctAnswers += 1}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else {return}
            self.imageView.layer.borderWidth = 0
            self.enableAndDisableButtonsSwitcher()
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questionAmount - 1 {
            guard let statisticService else {return}
            let massageForAlert =
            statisticService.store(gameTry: GameResult(correct: correctAnswers,
                                                        total: 10,
                                                        date: Date()))
            alertPresenter.alertCreate(quiz: AlertModel(
            title: "Этот раунд окончен",
                message: massageForAlert,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    guard let self else {return}
                    guard let questionFactory = self.questionFactory else{ return}
                    questionFactory.requestNextQuestion()} ))
            currentQuestionIndex = 0
            correctAnswers = 0
            
        }
        else {
            currentQuestionIndex += 1
            guard let questionFactory = questionFactory else {return}
            questionFactory.requestNextQuestion()
        }
    }
    
    private func enableAndDisableButtonsSwitcher(){
        if yesButton.isEnabled{
            yesButton.isEnabled = false
            noButton.isEnabled = false}
        else{yesButton.isEnabled = true
            noButton.isEnabled = true}
    } 
}
