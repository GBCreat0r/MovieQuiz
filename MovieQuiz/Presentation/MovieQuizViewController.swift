import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var counterLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        let questionFactory = QuestionFactory()
       // questionFactory = QuestionFactory(delegate: self)
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
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
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var gamesPlayed: Int = 0
    private var bestScore: Int = 0
    private var averageScore: Double = 0
    private var averageScoreToString: String = ""
    private var summaryOfCorrectAnswers: Int = 0
    private var dateFormatter = DateFormatter()
    private var timeOfRecord: String = ""
    
    private let questionAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    
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
    
    /*private func show(quiz result: QuizResultsViewModel){
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText,
                                   style: .default) {[weak self] _ in
            guard let self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            //self.questionFactory!.requestNextQuestion()
            
            guard let questionFactory = self.questionFactory else {return}
            questionFactory.requestNextQuestion()
            //self.show(quiz: self.convert(question: self.questions[self.currentQuestionIndex]))
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }*/
    
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
            statCalculator()
            
            show(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен",
                text:
                "Ваш реультат: \(correctAnswers)/10" +
                "\n Колличество сыгранных квизов: \(gamesPlayed)" +
                "\n Рекорд: \(bestScore) \(timeOfRecord)" +
                "\n Средняя точность  \(averageScoreToString) %",
                buttonText: "Сыграть ещё раз")
            )
            
        }
        else {
            currentQuestionIndex += 1
            //questionFactory!.requestNextQuestion()
            guard let questionFactory = questionFactory else {return}
            questionFactory.requestNextQuestion()
            //show(quiz: convert(question: questions[currentQuestionIndex]))
        }
    }
    
    private func enableAndDisableButtonsSwitcher(){
        if yesButton.isEnabled{
            yesButton.isEnabled = false
            noButton.isEnabled = false}
        else{yesButton.isEnabled = true
            noButton.isEnabled = true}
    }
    
    private func statCalculator(){
        gamesPlayed += 1
        summaryOfCorrectAnswers += correctAnswers
        
        if bestScore < correctAnswers{
            bestScore = correctAnswers
            timeOfRecord = currentTime()
        }
        
        averageScore = Double(summaryOfCorrectAnswers) * 10 / Double(gamesPlayed)
        averageScoreToString = String(format: "%.2f", averageScore)
    }
    
    private func currentTime() -> String {
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        return dateFormatter.string(from: Date())
    }
}
