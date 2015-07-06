//
//  GameEnd.swift
//  Make2048
//
//  Created by Otavio Monteagudo on 7/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

class GameEnd: CCNode {
    /* linked objects */
    weak var messageLabel: CCLabelTTF!;
    weak var scoreLabel: CCLabelTTF!;
    
    /* cocos2d methods */
    
    // triggered by restart button. Reloads main scene, restarting the game.
    func newGame() {
        var mainScene = CCBReader.loadAsScene("MainScene");
        CCDirector.sharedDirector().presentScene(mainScene);
    }
    
    /* custom methods */
    
    // sets message to be displayed and displays final score
    func setMessage(message: String, score: Int) {
        self.messageLabel.string = message;
        self.scoreLabel.string = "\(score)";
    }
}
