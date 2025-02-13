//
//  MovieQuizViewControllerMock.swift
//  MovieQuizTests
//
//  Created by semrumyantsev on 13.02.2025.
//

import Foundation
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {}
    func highlightImageBorder(isCorrectAnswer: Bool) {}
    func enableAndDisableButtonsSwitcher(isEnable: Bool) {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func showNetworkError(message: String) {}
}
