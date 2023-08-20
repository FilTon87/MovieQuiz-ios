//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Anton Filipchuk on 20.07.2023.
//

import Foundation
import UIKit

class AlertPresenter {
    func showAlert(in vc: UIViewController, alertView: AlertModel) {
        let alert = UIAlertController(
            title: alertView.title,
            message: alertView.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: alertView.buttonText,
            style: .default) { clickAction in alertView.completion(clickAction)}
        
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
}
