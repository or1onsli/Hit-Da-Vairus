//
//  GameViewController.swift
//  Hit da Vairus: Save Private iMac
//
//  Created by Andrea Vultaggio on 27/10/2016.
//  Copyright © 2016 Fabio Cipriani. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class GameViewController: UIViewController {

    // MARK: @IBOutlets
    @IBOutlet weak var bestOf: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var currentPoints: UILabel!
    @IBOutlet weak var bestScoreLbl: UILabel!
    @IBOutlet weak var currentLevel: UILabel!
    @IBOutlet weak var gameOverImg: UIImageView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var restartGameBtn: UIButton!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var gameFieldView: UIView!
    @IBOutlet weak var iMacImg: UIImageView!
    
    // MARK: Custom Parameters
    var newGame: Engine?
    var levelWon = false
    var generateVairusTimer = Timer()
    var genVairTimInterval = 0.8
    var vairusToGenerate = 10, counter = 0
    var hits = 0
    var bestScore = 0
    var gameAudio: AVAudioPlayer!
    var soundEffectsPlayer: AVAudioPlayer!
    var vairusLaugh: AVAudioPlayer!
    
    // MARK: Overridden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initAudio(audioFileName: "gameAudio", audioType: "mp3")
        self.playVairusLaugh(audioFileName: "Vairus", audioType: "m4a")
        newGame = Engine(level: 1, difficulty: 0)
        configureUI()
        generateVairusTimer = Timer.scheduledTimer(timeInterval: genVairTimInterval, target: self, selector: #selector(GameViewController.generateNewVairus), userInfo: nil, repeats: true)
        
        startGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gameAudio.stop()
        soundEffectsPlayer.stop()
        vairusLaugh.stop()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches where self.gameFieldView.bounds.contains(touch.location(in: self.view)) {
            let touchPoint = touch.location(in: self.gameFieldView)
            for child: UIView in self.gameFieldView.subviews.reversed() where child is Vairus {
                let presentationLayer: CALayer = child.layer.presentation() ?? child.layer
                if presentationLayer.frame.contains(touchPoint) {
                    child.removeFromSuperview()
                    currentPoints.text = String(Int(currentPoints.text!)! + 1)
                    if let vir = child as? Vairus{
                        vir.stop()
                        DispatchQueue.main.async {
                            self.playSoundEffects(audioFileName: "VairusDead", audioType: "m4a")
                        }
                        
                        hits += 1
                        if hits == vairusToGenerate{
                           youWin()
                        }
                    }
                    else{
                        print("child is not a vairus or is nil!")
                    }
                    break
                }
            }
        }
    }
    
    // MARK: @IBActions
    @IBAction func restartGame(_ sender: UIButton) {
        stopVairuses()
        generateVairusTimer = Timer.scheduledTimer(timeInterval: genVairTimInterval, target: self, selector: #selector(GameViewController.generateNewVairus), userInfo: nil, repeats: true)
        for view in gameFieldView.subviews {
            if view is Vairus {
                print(view.center)
                view.removeFromSuperview()
            }
        }
        
        startGame()
    }
    @IBAction func mainPressed(_ sender: UIButton) {
        if levelWon {
            levelWon = false
            newGame?.level += 1
            vairusToGenerate += 3
            counter = 0
            hits = 0
            currentLevel.text = "LEVEL \(newGame!.level)"
            newGameAssetsSetup()
            generateVairusTimer = Timer.scheduledTimer(timeInterval: genVairTimInterval, target: self, selector: #selector(GameViewController.generateNewVairus), userInfo: nil, repeats: true)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(GameViewController.gameOver),
                                                   name: NSNotification.Name(rawValue: "gameOver"),
                                                   object: nil)
        } else {
            newGameAssetsSetup()
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    // MARK: Custom Functions
    func startGame() {
        newGameAssetsSetup()
        configureUI()
        generateNewVairus()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GameViewController.gameOver),
                                               name: NSNotification.Name(rawValue: "gameOver"),
                                               object: nil)
    }
    
    func newGameAssetsSetup() {
        pointsLbl.alpha = 1.0
        bestScoreLbl.alpha = 1.0
        bestOf.alpha = 1.0
        currentPoints.alpha = 1.0
        currentLevel.alpha = 1.0
        backgroundImg.alpha = 1.0
        iMacImg.alpha = 1.0
        iMacImg.image = UIImage(named: "mac_happy")
        restartGameBtn.isHidden = true
        mainBtn.isHidden = true
        gameOverImg.isHidden = true
    }
    
    func youWin() {
        NotificationCenter.default.removeObserver(self)
        stopVairuses()
        pointsLbl.alpha = 0.5
        bestScoreLbl.alpha = 0.5
        bestOf.alpha = 0.5
        currentPoints.alpha = 0.5
        currentLevel.alpha = 0.5
        gameFieldView.backgroundColor = .green
        backgroundImg.alpha = 0.5
        iMacImg.alpha = 0.5
        iMacImg.image = UIImage(named: "mac_happy")
        restartGameBtn.isHidden = true
        mainBtn.setImage(UIImage(named: "NextLevel"), for: .normal)
        mainBtn.isHidden = false
        gameOverImg.isHidden = false
        gameOverImg.image = UIImage(named: "youWin!")
        
        generateVairusTimer.invalidate()
        if Int(currentPoints.text!)! > bestScore {
            bestScore = Int(currentPoints.text!)!
            bestOf.text = "\(bestScore)"
        }
        levelWon = true
        
    }
    
    func gameOver() {
        NotificationCenter.default.removeObserver(self)
        stopVairuses()
        pointsLbl.alpha = 0.5
        bestScoreLbl.alpha = 0.5
        bestOf.alpha = 0.5
        currentPoints.alpha = 0.5
        currentLevel.alpha = 0.5
        gameFieldView.backgroundColor = .red
        backgroundImg.alpha = 0.5
        iMacImg.alpha = 0.5
        iMacImg.image = UIImage(named: "mac_dead")
        restartGameBtn.isHidden = false
        mainBtn.setImage(UIImage(named: "main"), for: .normal)
        mainBtn.isHidden = false
        gameOverImg.isHidden = false
        gameOverImg.image = UIImage(named: "gameover")
        generateVairusTimer.invalidate()
        if Int(currentPoints.text!)! > bestScore {
            bestScore = Int(currentPoints.text!)!
            bestOf.text = "\(bestScore)"
        }
        levelWon = false
    }
    
    func stopVairuses() {
        for child: UIView in self.gameFieldView.subviews.reversed() where child is Vairus {
            if let vir = child as? Vairus{
                vir.stop()
                vir.isUserInteractionEnabled = false
            }
            else{
                print("child is not a vairus or is nil!")
            }
        }
    }
    
    func generateNewVairus() {
        if counter < vairusToGenerate{
            let vairus = Vairus()
            vairus.start()
            gameFieldView.addSubview(vairus)
            counter += 1
        }
        else{
            generateVairusTimer.invalidate()
            generateVairusTimer = Timer()
            counter = 0
        }
        
    }
    
    func configureUI() {
        currentLevel.text = "LEVEL \(newGame!.level)"
        currentPoints.text = "0"
        counter = 0
        hits = 0
    }
    
    func initAudio(audioFileName: String, audioType: String) {
        let path = Bundle.main.path(forResource: audioFileName, ofType: audioType)
        
        do {
            gameAudio = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            gameAudio.prepareToPlay()
            gameAudio.numberOfLoops = -1
            gameAudio.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func playSoundEffects(audioFileName: String, audioType: String) {
        
        let path = Bundle.main.path(forResource: audioFileName, ofType: audioType)
        
        do {
            soundEffectsPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            soundEffectsPlayer.prepareToPlay()
            soundEffectsPlayer.numberOfLoops = 0
            soundEffectsPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func playVairusLaugh(audioFileName: String, audioType: String) {
        let path = Bundle.main.path(forResource: audioFileName, ofType: audioType)
        
        do {
            vairusLaugh = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            vairusLaugh.prepareToPlay()
            vairusLaugh.numberOfLoops = -1
            vairusLaugh.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
//    func updateTimerLbl() {
//        if(centesimiDiSecondo <= 0) {
//            secondi -= 1
//            centesimiDiSecondo = 9
//        } else {
//            centesimiDiSecondo -= Int(timer.timeInterval * 10)
//        }
//        gameTime.text = "\(secondi):\(centesimiDiSecondo)"
//        if secondi == 0, centesimiDiSecondo == 0 {
//            timer.invalidate()
//            self.youWin()
//        }
//    }
}

// MARK: String Extension for Int and Double casting
private extension String {
    struct Formatter {
        static let instance = NumberFormatter()
    }
    var doubleValue:Double? {
        return Formatter.instance.number(from: self)?.doubleValue
    }
    var integerValue:Int? {
        return Formatter.instance.number(from: self)?.intValue
    }
}
