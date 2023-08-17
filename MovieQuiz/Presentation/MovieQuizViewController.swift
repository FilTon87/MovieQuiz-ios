import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private let presenter = MovieQuizPresenter()
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quizstep: viewModel)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticService = StatisticServiceImplementation()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let errorScreen = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] _ in
                guard let self = self else {return}
                self.questionFactory?.loadData()
            })
        alertPresenter?.showAlert(alertView: errorScreen)
    }
    
    private func show(quizstep: QuizStepViewModel) {
        counterLabel.text = quizstep.questionNumber
        imageView.image = quizstep.image
        textLabel.text =   quizstep.question
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrect == true {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults() }
    }
    
    private func showNextQuestionOrResults() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        imageView.layer.borderWidth = 0
        if presenter.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
            guard let gamesCount = statisticService?.gamesCount else {return}
            guard let bestGame = statisticService?.bestGame else {return}
            guard let totalAccuracy = statisticService?.totalAccuracy else {return}
            let finalScreen = AlertModel(
                title: "Этот раунд окончен!",
                message: """
            Ваш результат \(correctAnswers)/\(presenter.questionsAmount)
            Количество сыгранных квизов: \(gamesCount)
            Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", totalAccuracy))%
            """,
                buttonText: "Сыграть еще раз",
                completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.presenter.resetQuestionIndex()
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                })
            alertPresenter?.showAlert(alertView: finalScreen)
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        let givenAnswer = true
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        let givenAnswer = false
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
}
        /*       // MARK: - JSON
         //print(NSHomeDirectory())
         var jsonURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         let fileName = "inception.json"
         jsonURL.appendPathComponent(fileName)
         let jsonString = try? String(contentsOf: jsonURL)
         
         func getMovie(from jsonString: String) -> Movie? {
         var movie: Movie? = nil
         do {
         guard let data = jsonString.data(using: .utf8) else {return nil}
         let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
         
         guard let json = json,
         let id = json["id"] as? String,
         let title = json["title"] as? String,
         let jsonYear = json["year"] as? String,
         let year = Int(jsonYear),
         let image = json["image"] as? String,
         let releaseDate = json["releaseDate"] as? String,
         let jsonRuntimeMins = json["runtimeMins"] as? String,
         let runtimeMins = Int(jsonRuntimeMins),
         let directors = json["directors"] as? String,
         let actorList = json["actorList"] as? [Any] else {
         return nil
         }
         var actors: [Actor] = []
         
         for actor in actorList {
         guard let actor = actor as? [String: Any],
         let id = actor["id"] as? String,
         let image = actor["image"] as? String,
         let name = actor["name"] as? String,
         let asCharacter = actor["asCharacter"] as? String else {return nil}
         
         let mainActor = Actor(id: id, image: image, name: name, asCharacter: asCharacter)
         actors.append(mainActor)
         }
         movie = Movie(id: id, title: title, year: year, image: image, releaseDate: releaseDate, runtimeMins: runtimeMins, directors: directors, actorList: actors)
         } catch {
         print("Faild to parse: \(jsonString)")
         }
         return movie
         do {
         guard let data = jsonString.data(using: .utf8) else {return nil}
         let movie = try JSONDecoder().decode(Movie.self, from: data)
         } catch {
         print("Failed to parse: \(error.localizedDescription)")
         }
         return movie
         }
         } */

/*
 // MARK: - Mock-данные
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
