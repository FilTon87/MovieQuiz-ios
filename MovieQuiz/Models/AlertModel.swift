//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Anton Filipchuk on 20.07.2023.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (UIAlertAction) -> Void
}
