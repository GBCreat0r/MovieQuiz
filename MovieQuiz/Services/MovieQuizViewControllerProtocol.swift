//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 12.02.2025.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func enableAndDisableButtonsSwitcher(isEnable: Bool)
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
