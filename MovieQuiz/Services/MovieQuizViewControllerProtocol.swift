//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Anton Filipchuk on 19.08.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quizstep: QuizStepViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showNextQuestion()
    func disableButton()
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
