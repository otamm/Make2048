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
}
