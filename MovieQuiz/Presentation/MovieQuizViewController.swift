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

        show(quiz: convert(question: questions[currentQuestionIndex]))
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        if questions[currentQuestionIndex].correctAnswer == true {
            showAnswerResult(isCorrect: true)}
        else{showAnswerResult(isCorrect: false)}
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        if questions[currentQuestionIndex].correctAnswer == false {
            showAnswerResult(isCorrect: true)}
        else{showAnswerResult(isCorrect: false)}
        
    }
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
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
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    
    struct QuizStepViewModel{
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    struct QuizResultsViewModel{
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
    }
    
    private func showAnswerResult(isCorrect: Bool){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {correctAnswers += 1}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questions.count - 1 {
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен",
                                            text: "Ваш реультат: \(correctAnswers)/10",
                                            buttonText: "сыграть ещё раз"))
            
        }
        else {
            currentQuestionIndex += 1
            show(quiz: convert(question: questions[currentQuestionIndex]))
        }
        
    }
}
/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
