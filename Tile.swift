//
//  Tile.swift
//  Make2048
//
//  Created by Otavio Monteagudo on 7/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

class Tile:CCNode {
    /* linked objects */
    // value of the number in the tile.
    weak var valueLabel:CCLabelTTF!;
    
    // background color of the tile, will change according to value in the label.
    weak var backgroundNode:CCNodeColor!;
    
    /* custom variables */
    var value: Int = 0 {
        didSet {
            self.valueLabel.string = "\(self.value)";
        }
    }
    
    /* cocos2d methods */
    func didLoadFromCCB() {
        self.value = Int(CCRANDOM_MINUS1_1() + 2) * 2; // generates either 2 or 4
    }
}
