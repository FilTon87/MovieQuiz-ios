import UIKit

final class MovieQuizViewController: UIViewController {

    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    
    struct QuizQuestion {
        let image: String
        let test: String
        let correctAnswer: Bool
    }
    
    struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }
    
    private let quiestions = [
        QuizQuestion(image: "The Godfather", test: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", test: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", test: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", test: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", test: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", test: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", test: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", test: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", test: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", test: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: "\(model.image)") ?? UIImage(), question: "\(model.test)", questionNumber: "\(currentQuestionIndex + 1) / \(quiestions.count)")
        return questionStep
    }
    
    private func show(quizstep: QuizStepViewModel) {
        counterLabel.text = quizstep.questionNumber
        imageView.image = quizstep.image
        textLabel.text = quizstep.question
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 1 // толщина рамки
        imageView.layer.cornerRadius = 6
        if isCorrect == true { imageView.layer.borderColor = UIColor.ypGreen.cgColor } else {imageView.layer.borderColor = UIColor.ypRed.cgColor}
        
    }

    
    @IBAction func yesButtonClicked(_ sender: Any) {
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == quiestions[currentQuestionIndex].correctAnswer)
    }
    
    
    @IBAction func noButtonClicked(_ sender: Any) {
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == quiestions[currentQuestionIndex].correctAnswer)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = quiestions[currentQuestionIndex]
        show(quizstep: convert(model: currentQuestion))
        
        
    }
}

/*
 Mock-данные
 
 
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
