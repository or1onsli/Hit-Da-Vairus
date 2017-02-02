//
//  gameBrain.swift
//  Hit da Vairus: Save Private iMac
//
//  Created by Andrea Vultaggio on 26/10/2016.
//  Copyright © 2016 Fabio Cipriani. All rights reserved.
//

import Foundation
import UIKit

class Engine {
    
    var level: Int, difficulty: Int
    var timer: Double, hitbox: Int
    
    var positionMap: Array<Array<CGPoint>>
    var timerInterval = Timer()
    
    init(level: Int, difficulty: Int){
        self.level = level
        self.difficulty = difficulty
        
        self.timer = 30.0
        
        self.hitbox = 0
        let row = Array(repeating: CGPoint(), count: 6)
        self.positionMap = Array(repeating: row, count: 4)
        
        
        
    }
    
    func start() -> Void {
//        for i in 0...3 {
//            for j in 0...5 {
//                self.positionMap[i][j] = CGPoint(x: positions[j].center.x, y: positions[j].center.y)
//            }
//        }
    }
    
    func gameOver() -> Void {
    }
}
