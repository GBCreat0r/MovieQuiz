//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 14.01.2025.
//

import Foundation
import UIKit


class AlertPresenter: AlertPresenterProtocol {
    weak var viewControler: UIViewController?
    func alertCreate(quiz model: AlertModel){
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText,
                                   style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        viewControler?.present(alert, animated: true)
    }
    
    init(viewControler: UIViewController? = nil) {
        self.viewControler = viewControler
    }
}
