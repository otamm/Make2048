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
        self.value = (Int(arc4random_uniform(UInt32(2))) + 1) * 2; // generates either 2 or 4; arc4random_uniform() will generate either 0 or 1,then 1 is added to it and the result is multiplied by 2.
    }
}
