//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 13.01.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
