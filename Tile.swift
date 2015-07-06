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
    
    // label value. Will be set to 0 by default, however, will be randomly set to 2 or 4 once spawned.
    var value: Int = 0 {
        didSet {
            self.valueLabel.string = "\(self.value)";
            self.updateColor();
        }
    }
    
    // keeps track of wheter or not the tile was spawned from a merge. Avoids an undesired chain of merged tiles merging again. 
    var mergedThisRound = false;
    
    /* cocos2d methods */
    func didLoadFromCCB() {
        self.value = (Int(arc4random_uniform(UInt32(2))) + 1) * 2; // generates either 2 or 4; arc4random_uniform() will generate either 0 or 1,then 1 is added to it and the result is multiplied by 2.
        //value = Int(CCRANDOM_MINUS1_1() * 201) + 201
    }
    
    /* custom methods */
    
    // once label gets updated, background color gets updated as well.
    func updateColor() {
        var backgroundColor: CCColor;
        
        switch self.value {
        case 2:
            backgroundColor = CCColor(red: 20.0/255, green: 20.0/255, blue: 80.0/255);
            break;
        case 4:
            backgroundColor = CCColor(red: 20.0/255, green: 20.0/255, blue: 140.0/255);
            break;
        case 8:
            backgroundColor = CCColor(red:20.0/255, green:60.0/255, blue:220.0/255);
            break;
        case 16:
            backgroundColor = CCColor(red:20.0/255, green:120.0/255, blue:120.0/255);
            break;
        case 32:
            backgroundColor = CCColor(red:20.0/255, green:160.0/255, blue:120.0/255);
            break;
        case 64:
            backgroundColor = CCColor(red:20.0/255, green:160.0/255, blue:60.0/255);
            break;
        case 128:
            backgroundColor = CCColor(red:50.0/255, green:160.0/255, blue:60.0/255);
            break;
        case 256:
            backgroundColor = CCColor(red:80.0/255, green:120.0/255, blue:60.0/255);
            break;
        case 512:
            backgroundColor = CCColor(red:140.0/255, green:70.0/255, blue:60.0/255);
            break;
        case 1024:
            backgroundColor = CCColor(red:170.0/255, green:30.0/255, blue:60.0/255);
            break;
        case 2048:
            backgroundColor = CCColor(red:220.0/255, green:30.0/255, blue:30.0/255);
            break;
        default:
            backgroundColor = CCColor.greenColor();
            break;
        }
        
        self.backgroundNode.color = backgroundColor;
    }
}
