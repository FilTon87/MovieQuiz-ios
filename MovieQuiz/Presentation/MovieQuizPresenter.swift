//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Anton Filipchuk on 17.08.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private let statisticService: StatisticService!
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var alertPresenter = AlertPresenter()
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        self.showNetworkError(message: error.localizedDescription)
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quizstep: viewModel)
        }
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }

    //MARK: - Private func
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
        if givenAnswer == currentQuestion.correctAnswer {
            self.proceedWithAnswer(isCorrect: true)
            correctAnswers += 1
        } else {
            self.proceedWithAnswer(isCorrect: false)
        }
        viewController?.disableButton()
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults() }
    }
    
    //MARK: - AlertPresenter
    
    private func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator()
        let errorScreen = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] _ in
                guard let self = self else {return}
                self.questionFactory?.loadData()
            })
        alertPresenter.showAlert(in: viewController as! UIViewController, alertView: errorScreen)
    }
    
    private func proceedToNextQuestionOrResults() {
        viewController?.showNextQuestion()
        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            guard let gamesCount = statisticService?.gamesCount else {return}
            guard let bestGame = statisticService?.bestGame else {return}
            guard let totalAccuracy = statisticService?.totalAccuracy else {return}
            let finalScreen = AlertModel(
                title: "Этот раунд окончен!",
                message: """
            Ваш результат \(correctAnswers)/\(self.questionsAmount)
            Количество сыгранных квизов: \(gamesCount)
            Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", totalAccuracy))%
            """,
                buttonText: "Сыграть еще раз",
                completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.restartGame()
                })
            alertPresenter.showAlert(in: viewController as! UIViewController, alertView: finalScreen)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}
