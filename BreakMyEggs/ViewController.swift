//
//  ViewController.swift
//  Hit da Vairus: Save Private iMac
//
//  Created by Fabio Cipriani on 26/10/16.
//  Copyright © 2016 Fabio Cipriani. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {

    @IBOutlet weak var mainTitleLbl: UIImageView!
    @IBOutlet weak var subtitleLbl: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var leaderboardBtn: UIButton!
    
    var musicPlayer: AVAudioPlayer!
    var mainTitleY: CGFloat = 0.0
    var subtitleY: CGFloat = 0.0
    var playBtnY: CGFloat = 0.0
    var leaderboardBtnY: CGFloat = 0.0
    
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAssets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureAssets()
        introAnimation()
    }
    override func viewWillAppear(_ animated: Bool) {
        initAudio(audioFileName: "menuAudio", audioType: "mp3")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        musicPlayer.stop()
    }
    
    func configureAssets() {
        mainTitleLbl.alpha = 0.0
        subtitleLbl.alpha = 0.0
        playBtn.alpha = 0.0
        leaderboardBtn.alpha = 0.0
        
        mainTitleLbl.center.y = 27.5 - 20.0
        subtitleLbl.center.y = 63.5 - 20.0
        playBtn.center.y = 32.5 - 20
        leaderboardBtn.center.y = 112.0 - 20
    }
    
    func fadeInAssets() {
        mainTitleLbl.alpha = 1.0
        subtitleLbl.alpha = 1.0
        playBtn.alpha = 1.0
        leaderboardBtn.alpha = 1.0
    }
    
    func animateLabels() {
        mainTitleLbl.center.y -= -20
        subtitleLbl.center.y -= -20
        playBtn.center.y -= -20
        leaderboardBtn.center.y -= -20
    }
    
    func introAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.fadeInAssets()
            self.animateLabels()
        }, completion: nil)
    }
    
    func initAudio(audioFileName: String, audioType: String) {
        let path = Bundle.main.path(forResource: audioFileName, ofType: audioType)
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = 0
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

}

