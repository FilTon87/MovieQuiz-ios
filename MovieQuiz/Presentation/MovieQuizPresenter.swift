//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Anton Filipchuk on 17.08.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func yesButtonClicked() {
        let givenAnswer = true
        guard let currentQuestion = currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        viewController?.yesButton.isEnabled = false
        viewController?.noButton.isEnabled = false
    }
    
    func noButtonClicked() {
        let givenAnswer = false
        guard let currentQuestion = currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        viewController?.yesButton.isEnabled = false
        viewController?.noButton.isEnabled = false
    }
    
}
