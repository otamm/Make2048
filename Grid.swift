//
//  Grid.swift
//  Make2048
//
//  Created by Otavio Monteagudo on 7/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

class Grid:CCNodeColor {
    /* custom variables */
    
    let gridSize = 4;
    var columnWidth: CGFloat = 0;
    var columnHeight: CGFloat = 0;
    var tileMarginVertical: CGFloat = 0;
    var tileMarginHorizontal: CGFloat = 0;
    
    /* custom methods */
    func setupBackground() {
        
        var tile = CCBReader.load("Tile") as! Tile;
        self.columnWidth = tile.contentSize.width;
        self.columnHeight = tile.contentSize.height;
        
        self.tileMarginHorizontal = (contentSize.width - (CGFloat(gridSize) * columnWidth)) / CGFloat(gridSize + 1);
        self.tileMarginVertical = (contentSize.height - (CGFloat(gridSize) * columnHeight)) / CGFloat(gridSize + 1);
        
        var x = tileMarginHorizontal;
        var y = tileMarginVertical;
        
        // fills four columns at once, then moves to the next row.
        for i in 0..<gridSize {
            x = self.tileMarginHorizontal;
            for j in 0..<gridSize {
                var backgroundTile = CCNodeColor.nodeWithColor(CCColor.grayColor());
                backgroundTile.contentSize = CGSize(width: columnWidth, height: columnHeight);
                backgroundTile.position = CGPoint(x: x, y: y);
                self.addChild(backgroundTile);
                x += columnWidth + tileMarginHorizontal;
            }
            
            y += columnHeight + tileMarginVertical;
        }
    }
    
    /* cocos2d methods */
    func didLoadFromCCB() {
        self.setupBackground();
    }
    
}
