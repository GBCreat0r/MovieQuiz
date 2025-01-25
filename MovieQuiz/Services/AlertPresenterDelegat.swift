//
//  AlertPresenterPortocol.swift
//  MovieQuiz
//
//  Created by semrumyantsev on 14.01.2025.
//

import Foundation
import UIKit
protocol AlertPresenterDelegat: AnyObject {
    func showAlert(alert: UIAlertController?)
}
