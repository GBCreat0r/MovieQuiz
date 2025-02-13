//
//  ControllerTests.swift
//  MovieQuizTests
//
//  Created by semrumyantsev on 12.02.2025.
//

import XCTest
@testable import MovieQuiz


final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion (imageData: emptyData,
                                     text: "Question text",
                                     correctAnswer: true)
        let viewModel = presenter.convert(question: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
