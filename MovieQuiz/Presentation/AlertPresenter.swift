//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 14.01.2025.
//

import Foundation
import UIKit


final class AlertPresenter: AlertPresenterProtocol {
    weak var viewController: UIViewController?
    func alertCreate(quiz model: AlertModel){
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: model.buttonText,
                                   style: .default) { _ in
            model.completion()
        }
        alert.view.accessibilityIdentifier = "alert"
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}
