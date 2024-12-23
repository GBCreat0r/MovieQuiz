import UIKit


final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        show(quiz: convert(question: questions[currentQuestionIndex]))
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        enableAndDisableButtonsSwitcher()
        
        if questions[currentQuestionIndex].correctAnswer == true {
            
            showAnswerResult(isCorrect: true)}
        else{showAnswerResult(isCorrect: false)}
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        enableAndDisableButtonsSwitcher()
        
        if questions[currentQuestionIndex].correctAnswer == false {
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
    
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     text: "Рейтинг этого фильма больше 6",
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     text: "Рейтинг этого фильма больше 6",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "Рейтинг этого фильма больше 6",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "Рейтинг этого фильма больше 6",
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     text: "Рейтинг этого фильма больше 6",
                     correctAnswer: true),
        QuizQuestion(image:"The Green Knight",
                     text:"Рейтинг этого фильма больше 6",
                     correctAnswer: true),
        QuizQuestion(image:"Old",
                     text:"Рейтинг этого фильма больше 6",
                     correctAnswer: false),
        QuizQuestion(image:"The Ice Age Adventures of Buck Wild" ,
                     text:"Рейтинг этого фильма больше 6",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     text:"Рейтинг этого фильма больше 6",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text:"Рейтинг этого фильма больше 6",
                     correctAnswer: false)
    ]
    
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    
    private struct QuizStepViewModel{
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private struct QuizResultsViewModel{
        let title: String
        let text: String
        let buttonText: String
    }
    
    private func convert(question: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(
            image : UIImage(named: question.image) ?? UIImage(),
            question: question.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questions.count)"
        )
        return quizStepViewModel
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel){
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText,
                                   style: .default) {_ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.show(quiz: self.convert(question: self.questions[self.currentQuestionIndex]))
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func showAnswerResult(isCorrect: Bool){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {correctAnswers += 1}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderWidth = 0
            self.enableAndDisableButtonsSwitcher()
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questions.count - 1 {
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
            
            show(quiz: convert(question: questions[currentQuestionIndex]))
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
