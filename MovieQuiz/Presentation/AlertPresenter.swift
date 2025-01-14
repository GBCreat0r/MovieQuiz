//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 14.01.2025.
//

import Foundation
import UIKit


class AlertPresenter {
     func show(quiz result: QuizResultsViewModel){
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
    }
    
}
