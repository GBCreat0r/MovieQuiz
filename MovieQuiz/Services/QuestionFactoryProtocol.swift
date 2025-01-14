//
//  QuestionsFactoryProtocol.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 09.01.2025.
//

import Foundation


protocol QuestionFactoryProtocol {
    //var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
}
