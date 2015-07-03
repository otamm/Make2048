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
    // array of tile instances arrays; represents the main game grid. Space can or cannot have a tile on it.
    var gridArray = [[Tile?]]();
    var noTile:Tile? = nil;
    let gridSize = 4;
    // number of initial tiles when game is launched
    let startTiles = 2;
    var columnWidth: CGFloat = 0;
    var columnHeight: CGFloat = 0;
    var tileMarginVertical: CGFloat = 0;
    var tileMarginHorizontal: CGFloat = 0;
    
    /* custom methods */
    
    // sets up a grid of (gridSize) rows by (gridSize) columns for (gridSize ** 2) tiles, with a margin space between any two tiles inside it.
    func setupBackground() {
        
        var tile = CCBReader.load("Tile") as! Tile; // loads a Tile instance
        self.columnWidth = tile.contentSize.width; // gets the tile object width, then gets its height
        self.columnHeight = tile.contentSize.height;
        // set a margin proportional to the Tile object's height & width
        self.tileMarginHorizontal = (self.contentSize.width - (CGFloat(self.gridSize) * self.columnWidth)) / CGFloat(self.gridSize + 1);
        self.tileMarginVertical = (self.contentSize.height - (CGFloat(self.gridSize) * self.columnHeight)) / CGFloat(self.gridSize + 1);
        
        var x = self.tileMarginHorizontal;
        var y = self.tileMarginVertical;
        
        // fills four columns at once, then moves to the next row.
        // each element inside an array element of gridArray will be either nil or a Tile object. Initially the grid is set up containing only nil elements (even though the memory is allocated to hold (gridSize * gridSize) Tile elements); Tile instances will be randomly assigned later.
        for i in 0..<self.gridSize {
            x = self.tileMarginHorizontal;
            for j in 0..<self.gridSize {
                // sets background color for space without a tile on it (gray, in this case)
                var backgroundTile = CCNodeColor.nodeWithColor(CCColor.grayColor());
                backgroundTile.contentSize = CGSize(width: self.columnWidth, height: self.columnHeight);
                backgroundTile.position = CGPoint(x: x, y: y);
                self.addChild(backgroundTile);
                x += self.columnWidth + self.tileMarginHorizontal;
            }
            
            y += self.columnHeight + self.tileMarginVertical;
        }
    }
    
    // returns position for a given tile index inside the grid. To be used alongside spawnRandomTile, as it will point to the position of the space containing 'nil'.
    func positionForColumn(column: Int, row: Int) -> CGPoint {
        var x = self.tileMarginHorizontal + CGFloat(column) * (self.tileMarginHorizontal + self.columnWidth);
        var y = self.tileMarginVertical + CGFloat(row) * (self.tileMarginVertical + self.columnHeight);
        return CGPoint(x: x, y: y);
    }
    
    // adds tile to specific space
    func addTileAtColumn(column: Int, row: Int) {
        var tile = CCBReader.load("Tile") as! Tile; // loads tile and stores it locally
        self.gridArray[column][row] = tile; // appends it to gridArray
        tile.scale = 0; // sets tile's scale to 0 as a maneuver to make tile appear with a 'scale up' animation
        self.addChild(tile);
        tile.position = self.positionForColumn(column, row: row);
        // creates action sequence: starting with scale 0, tile is invisible; waits for 0.3 seconds and then scale tile up to full size in 0.2 seconds.
        var delay = CCActionDelay(duration: 0.3);
        var scaleUp = CCActionScaleTo(duration: 0.2, scale: 1);
        var sequence = CCActionSequence(array: [delay, scaleUp]);
        tile.runAction(sequence);
    }
    
    // generates a random position. Then, checks if the position is already occupied in the grid. If it is, generates another random position. If it's not, sets the position as 'spawned', marking it as the next space to add a tile.
    // at first, this approach is fine. However, once the game is active for a while, most positions will aready have tiles on them. Since the game is so simple, this can be ignored for now.
    func spawnRandomTile() {
        var spawned = false;
        while !spawned {
            let randomRow = Int(CCRANDOM_0_1() * Float(self.gridSize))
            let randomColumn = Int(CCRANDOM_0_1() * Float(self.gridSize))
            let positionFree = self.gridArray[randomColumn][randomRow] == self.noTile
            
            if positionFree {
                self.addTileAtColumn(randomColumn, row: randomRow)
                spawned = true
            }
        }
    }

    
    // checks the array for spaces set to hold tiles and spawns a tile at these spaces
    func spawnStartTiles() {
        for i in 0..<self.startTiles {
            self.spawnRandomTile();
        }
    }
    
    /* iOS methods */
    
    // swipe-related methods below are not iOS native, however, they use a lot of iOS components and therefore its classification as so is convenient.
    
    // actions to be called at each swipe; to be implemented
    
    func swipeLeft() { // to be implemented
        println("Left swipe!");
    }
    
    func swipeRight() { // to be implemented
        println("Right swipe!");
    }
    
    func swipeUp() { // to be implemented
        println("Up swipe!");
    }
    
    func swipeDown() { // to be implemented
        println("Down swipe!");
    }
    
    // sets up actions to be triggered once a swipe is detected in a given direction.
    // adds 4 listeners for swipes (for up, down, left and right directions); gesture recognizers are added to a UIView. The main UIView in a Cocos2d app is the OpenGL view used to render the entire content of the Cocos2d app. This UIView is accessed through the '.view' property of CCDirector; the UISwipeGestureRecognizer allows a specific swipe direction to be associated with a specific method.
    func setupGestures() {
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeLeft");
        swipeLeft.direction = .Left;
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeLeft);
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "swipeRight");
        swipeRight.direction = .Right;
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeRight);
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "swipeUp");
        swipeUp.direction = .Up;
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeUp);
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "swipeDown");
        swipeDown.direction = .Down;
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeDown);
    }
    
    
    /* cocos2d methods */
    
    // run when object is loaded into scene; will set up grid and then add objects
    func didLoadFromCCB() {
        self.setupBackground();
        // after setting up the gridArray, the 'noTile' value is stored for each index. Then, self.spawnStartTiles(); is called to add tiles where needed (random locations, variable in each game session).
        for i in 0..<self.gridSize {
            var column = [Tile?]();
            for j in 0..<self.gridSize {
                column.append(self.noTile); // creates an array of 'nil or Tile' objects
            }
            self.gridArray.append(column); // adds the past array to the final array
        }
        
        self.spawnStartTiles(); // adds tiles to spaces set to display one
        self.setupGestures(); // associates each gesture detected with a specific action
    }
    
}
