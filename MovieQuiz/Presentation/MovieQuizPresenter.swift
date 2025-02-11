//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 10.02.2025.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var correctAnswers: Int = 0
    let questionAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    let statisticService: StatisticServiceProtocol!
    var questionFactory: QuestionFactoryProtocol?
    var alertPresenter: AlertPresenterProtocol?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        statisticService = StatisticService()

        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
        alertPresenter = AlertPresenter(viewController: self.viewController)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(question: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(
            image : UIImage(data: question.imageData) ?? UIImage(),
            question: question.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questionAmount)"
        )
        return quizStepViewModel
    }
    
    func yesButtonClicked() {
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    func noButtonClicked() {
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
    func showNextQuestionOrResults(){
        if self.isLastQuestion() {
            guard let statisticService else { return }
            let massageForAlert =
            statisticService.store(gameTry: GameResult(correct: correctAnswers,
                                                       total: 10,
                                                       date: Date()))
            alertPresenter?.alertCreate(quiz: AlertModel(
                title: "Этот раунд окончен!",
                message: massageForAlert,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    guard let self else { return }
                    guard let questionFactory = self.questionFactory
                    else { return }
                    questionFactory.requestNextQuestion() }))
            restartGame()
        }
        else {
            self.switchToNextQuestion()
            guard let questionFactory = questionFactory else { return }
            questionFactory.requestNextQuestion()
        }
    }
    func showAnswerResult(isCorrect: Bool){
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        if isCorrect {correctAnswers += 1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    // MARK:- QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(question: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    func didLoadDataFromServer() {
        viewController?.activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
}
