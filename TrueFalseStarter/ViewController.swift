
import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    var trivia = QuestionManager().questions
    let questionsPerGame = QuestionManager().questions.count
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion:  Int = 0
    let delayBetweenQuestions = 1   // seconds
    
    // Audio variables
    var gameSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 1
    var wrongSound: SystemSoundID = 2
    
    // Lightning round variables
    var playTime = 40  // Seconds
    let staticPlayTime = 40 // Seconds
    var timer = Timer()
    
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        loadAnswerSounds()
        // Start game
        playGameStartSound()
        runTimer()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        // trivia.count-1 to avoid index out of bound
        if trivia.count-1 >= 0 {
            // branch to avoid Int Overflow
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count-1)
        }
        let questionPack = trivia[indexOfSelectedQuestion]
        questionField.text = questionPack.question
        option1.setTitle(questionPack.option1, for: .normal)
        option2.setTitle(questionPack.option2, for: .normal)
        option3.setTitle(questionPack.option3, for: .normal)
        // Mix of three/4 option feature
        if questionPack.option4 != nil {
            option4.isHidden = false
            option4.setTitle(questionPack.option4, for: .normal)
        } else {
            option4.isHidden = true
        }
        
        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        option1.isHidden = true
        option2.isHidden = true
        option3.isHidden = true
        option4.isHidden = true
        timerLabel.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsAsked) correct!"
    }
    
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionPack = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionPack.correctAnswer
        
        if sender.title(for: .normal) == correctAnswer {
            correctQuestions += 1
            questionField.text = "Correct!"
            playCorrectAnswerSound()
            // Remove the question from the array so each question shows up once
            trivia.remove(at: indexOfSelectedQuestion)
        } else {
            questionField.text = "Sorry, wrong answer!"
            playWrongAnswerSound()
            trivia.remove(at: indexOfSelectedQuestion)
            
            // Pulsate the correct answer --- Extra credit
            switch correctAnswer {
            case option1.currentTitle!:
                option1.pulsate()
            case option2.currentTitle!:
                option2.pulsate()
            case option3.currentTitle!:
                option3.pulsate()
            case option4.currentTitle!:
                option4.pulsate()
            default: print("")
            }
            
        }
        
        loadNextRoundWithDelay(seconds: delayBetweenQuestions)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerGame {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the options buttons
        option1.isHidden = false
        option2.isHidden = false
        option3.isHidden = false
        option4.isHidden = false
        timerLabel.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        resetTimer()
        populateQuestionsArray()
        nextRound()
    }
    
    
    // MARK: Helper Methods //
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    
    // load and play sounds for correct and wrong answer
    func loadAnswerSounds() {
        let pathToCorrectSoundFile = Bundle.main.path(forResource: "Correct", ofType: "wav")
        let correctSoundURL = URL(fileURLWithPath: pathToCorrectSoundFile!)
        AudioServicesCreateSystemSoundID(correctSoundURL as CFURL, &correctSound)
        
        let pathToWrongSoundFile = Bundle.main.path(forResource: "Fail", ofType: "wav")
        let wrongSoundURL = URL(fileURLWithPath: pathToWrongSoundFile!)
        AudioServicesCreateSystemSoundID(wrongSoundURL as CFURL, &wrongSound)
    }
    
    func playCorrectAnswerSound() {
        AudioServicesPlaySystemSound(correctSound)
    }
    
    func playWrongAnswerSound() {
        AudioServicesPlaySystemSound(wrongSound)
    }
    
    
    // populate the question array for new game
    func populateQuestionsArray() {
        trivia = QuestionManager().questions
    }
    
    // Helper functions for lighting round
    // The main countdown timer for the game
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    // Showing the countdown on screen
    func updateTimer() {
        if playTime > 0 {
            playTime -= 1
            timerLabel.text = "\(playTime)"
        } else if playTime == 0 {
            // if countdown is 0 game is over and display score
            displayScore()
        }
    }
    
    func resetTimer() {
        playTime = staticPlayTime
    }

}


// extending UIButton to pulsate the correct answer
extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
}

