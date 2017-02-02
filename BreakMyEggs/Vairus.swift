//
//  vairus.swift
//  Hit da Vairus: Save Private iMac
//
//  Created by Fabio Cipriani on 02/11/16.
//  Copyright © 2016 Fabio Cipriani. All rights reserved.
//

import Foundation
import UIKit

class Vairus: UIButton {
    var timer = Timer()
    var timerInterval = 0.7
    var yPoints: [CGFloat] = [43, 116, 190, 260]
    var xPoints: [CGFloat] = [628, 545, 452, 380, 295, 210]
    var currentXPos = 0
    
    func start(){
        self.setImage(UIImage(named: "vairus.png"), for: .normal)
        self.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
        let yPos = Int(arc4random_uniform(4))
        self.center = CGPoint(x: xPoints[currentXPos], y: yPoints[yPos])
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(self.moveVairus), userInfo: nil, repeats: true)
        }
    }
    
    func stop() {
        timer.invalidate()
        timer = Timer()
        let yPos = Int(arc4random_uniform(4))
        self.center = CGPoint(x: xPoints[0], y: yPoints[yPos])
    }
    
    func moveVairus() {
        if self.currentXPos + 1 < 6 {
            DispatchQueue.main.async {
                let keyFrameAnimation = CAKeyframeAnimation(keyPath:"position")
                let mutablePath = CGMutablePath()
                mutablePath.move(to: self.center)
                let yPos = Int(arc4random_uniform(4))
                self.currentXPos += 1
                mutablePath.addQuadCurve(to: CGPoint(x: self.xPoints[self.currentXPos] , y: self.yPoints[yPos]), control: CGPoint(x: (self.center.x + self.xPoints[1])/2, y: self.yPoints[yPos]/2))
                keyFrameAnimation.path = mutablePath
                keyFrameAnimation.duration = 0.7
                keyFrameAnimation.fillMode = kCAFillModeForwards
                keyFrameAnimation.isRemovedOnCompletion = false
                self.layer.add(keyFrameAnimation, forKey: "animation")
                self.center = CGPoint(x: self.xPoints[self.currentXPos] , y: self.yPoints[yPos])
            }
        } else {
            let iMacCenter = CGPoint(x: 73.5, y: 152.5)
            let keyFrameAnimation = CAKeyframeAnimation(keyPath:"position")
            let mutablePath = CGMutablePath()
            mutablePath.move(to: self.center)
            let yPos = Int(arc4random_uniform(4))
            self.currentXPos += 1
            mutablePath.addQuadCurve(to: iMacCenter, control: CGPoint(x: (self.center.x + self.xPoints[1])/2, y: self.yPoints[yPos]/2))
            keyFrameAnimation.path = mutablePath
            keyFrameAnimation.duration = 0.7
            keyFrameAnimation.fillMode = kCAFillModeForwards
            keyFrameAnimation.isRemovedOnCompletion = false
            self.layer.add(keyFrameAnimation, forKey: "animation")
            self.center = iMacCenter
        }
        if currentXPos == 7 {
            NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "gameOver"), object: nil) as Notification)
        }
    }
}
