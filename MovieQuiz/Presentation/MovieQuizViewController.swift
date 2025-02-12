import UIKit


final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var counterLabel: UILabel!
    
    private var presenter: MovieQuizPresenter!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        
        /* UserDefaults.standard.set(true, forKey: "viewDidLoad")
         print(Bundle.main.bundlePath)
         print(NSHomeDirectory()) */
        
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    //MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        enableAndDisableButtonsSwitcher(isEnable: false)
        presenter.yesButtonClicked()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        enableAndDisableButtonsSwitcher(isEnable: false)
        presenter.noButtonClicked()
    }
    
    //MARK: - Funcions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
        self.enableAndDisableButtonsSwitcher(isEnable: true)
        self.imageView.layer.borderWidth = 0
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func enableAndDisableButtonsSwitcher(isEnable: Bool){
        noButton.isEnabled = isEnable
        yesButton.isEnabled = isEnable
    }
    
    func showLoadingIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating( )
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String){
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText:"Попробовать ещё раз") { [weak self] in
            guard let self else { return }
            self.presenter.restartGame()
        }
        presenter.makeAlert(model: model)
    }
}
