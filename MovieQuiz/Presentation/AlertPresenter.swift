//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Anton Filipchuk on 20.07.2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: UIViewController?
    init (delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showAlert(alertView: AlertModel) {
        let alert = UIAlertController(
            title: alertView.title,
            message: alertView.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: alertView.buttonText,
            style: .default) { clickAction in alertView.completion(clickAction)}
        
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
