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
            //let randomRow = Int(CCRANDOM_0_1() * Float(self.gridSize));
            //let randomColumn = Int(CCRANDOM_0_1() * Float(self.gridSize));
            let randomRow = Int(arc4random_uniform(UInt32(self.gridSize)));
            let randomColumn = Int(arc4random_uniform(UInt32(self.gridSize)));
            let positionFree = (self.gridArray[randomColumn][randomRow] == self.noTile);
            
            if positionFree {
                self.addTileAtColumn(randomColumn, row: randomRow);
                spawned = true;
            }
        }
    }

    
    // checks the array for spaces set to hold tiles and spawns a tile at these spaces
    func spawnStartTiles() {
        for i in 0..<self.startTiles {
            self.spawnRandomTile();
        }
    }
    
    // returns 'true' if the index is inside the grid and 'false' otherwise.
    func indexValid(x: Int, y: Int) -> Bool {
        var indexValid = true;
        indexValid = (x >= 0) && (y >= 0);
        if indexValid {
            indexValid = x < Int(self.gridArray.count);
            if indexValid {
                indexValid = y < Int(self.gridArray[x].count);
            }
        }
        return indexValid;
    }
    
    // returns 'true' if the index is inside the grid/does not contain a Tile object and 'false' otherwise.
    func indexValidAndUnoccupied(x: Int, y: Int) -> Bool {
        var indexValid = self.indexValid(x, y: y);
        if !indexValid {
            return false;
        }
        // unoccupied?
        return self.gridArray[x][y] == self.noTile;
    }
    
    // receives the Tile instance to be moved, its starting point and its finish point.
    func moveTile(tile: Tile, fromX: Int, fromY: Int, toX: Int, toY: Int) {
        
        self.gridArray[toX][toY] = self.gridArray[fromX][fromY]; // adds tile to new index
        self.gridArray[fromX][fromY] = self.noTile;// removes tile from old index
        
        var newPosition = self.positionForColumn(toX, row: toY); // gets a CGPoint for new index
        var moveTo = CCActionMoveTo(duration: 0.2, position: newPosition); // sets animation (tile moving from old index to new index)
        tile.runAction(moveTo); // runs animation for moving tile
    }
    
    // if two tiles' indexes are the same, merge them into a single tile with index being equal to the sum of the two equal indexes.
    func mergeTilesAtindex(x: Int, y: Int, withTileAtIndex otherX: Int, y otherY: Int) {
        // Update game data
        var mergedTile = self.gridArray[x][y]!; // sets tile at position [x][y] as the one to occupied by the result of the merge        
        var otherTile = self.gridArray[otherX][otherY]!; // sets tile which will be combined with the new tile
        
        self.gridArray[x][y] = self.noTile; // excludes tile that is currently at position [x][y], since this position will be occupied for a tile with a label 2x its value
        
        // Update the UI
        var otherTilePosition = self.positionForColumn(otherX, row: otherY); // gets the CGPoint for the tile which will move;
        var moveTo = CCActionMoveTo(duration:0.2, position: otherTilePosition); // sets up animation for movement of moving tile from its current position to its final position, with a time of 0.2 seconds.
        var remove = CCActionRemove(); // removes tile that will give place to mergedTitle; last action to be executed in a sequence which will be passed to mergedTitle.
        
        var mergeTile = CCActionCallBlock(block: { () -> Void in
            otherTile.value *= 2;
            otherTile.mergedThisRound = true; // indicates that otherTile was produced from a merge.
        }); // sets a closure which will update the tile's current value to 2*(tile's current value);
        /*var checkWin = CCActionCallBlock(block: { () -> Void in
            if otherTile.value == self.winTile {self.win()}
        });*/
        //sets up a sequence of actions to be executed;
        //var sequence = CCActionSequence(array: [moveTo, mergeTile, checkWin, remove]);
        var sequence = CCActionSequence(array: [moveTo, mergeTile, remove]);
        mergedTile.runAction(sequence); // runs the sequence of actions at the tile currently positioned at the index which will give place to the merged tile
    }
    
    // a "change state" method to be triggered whenever any tile changes its position in the grid.
    func nextRound() {
        self.spawnRandomTile(); // spawns a random title in an unnocupied spot
        // sets all tiles' mergedThisRound property to false so any tile that resulted from a merge can merge once again.
        for column in self.gridArray {
            for tile in column {
                tile?.mergedThisRound = false;
            }
        }
    }
    /* iOS methods */
    
    /****** SWIPE METHODS *****/
    // swipe-related methods below are not iOS native, however, they use a lot of iOS components and therefore its classification as so is convenient.
    
    // actual implementation of movement. Called at each swipe, with varying directions.
    func move(direction: CGPoint) {
        var movedTilesThisRound = false; // if any tile has effectively moved, a new tile must be spawned.
        // apply negative vector until reaching boundary, this way we get the tile that is further away
        // bottom left corner
        var currentX = 0;
        var currentY = 0;
        // Move to relevant edge by applying direction until reaching border
        while self.indexValid(currentX, y: currentY) {
            var newX = currentX + Int(direction.x);
            var newY = currentY + Int(direction.y);
            if self.indexValid(newX, y: newY) {
            //if self.indexValid(newX, y: newY) {
                currentX = newX;
                currentY = newY;
            } else {
                break;
            }
        }
        // store initial row value to reset after completing each column
        var initialY = currentY;
        // define changing of x and y value (moving left, up, down or right?)
        var xChange = Int(-direction.x);
        var yChange = Int(-direction.y);
        if xChange == 0 {
            xChange = 1;
        }
        if yChange == 0 {
            yChange = 1;
        }
        // visit column for column
        while self.indexValid(currentX, y: currentY) {
            while self.indexValid(currentX, y: currentY) {
                // get tile at current index
                if let tile = gridArray[currentX][currentY] {
                    // if tile exists at index
                    var newX = currentX;
                    var newY = currentY;
                    // find the farthest position by iterating in direction of the vector until reaching boarding of
                    // grid or occupied cell
                    while self.indexValidAndUnoccupied(newX+Int(direction.x), y: newY+Int(direction.y)) {
                        newX += Int(direction.x);
                        newY += Int(direction.y);
                    }
                    var performMove = false
                    // If we stopped moving in vector direction, but next index in vector direction is valid, this
                    // means the cell is occupied. Let's check if we can merge them...
                    if self.indexValid(newX+Int(direction.x), y: newY+Int(direction.y)) {
                        // get the other tile
                        var otherTileX = newX + Int(direction.x);
                        var otherTileY = newY + Int(direction.y);
                        if let otherTile = self.gridArray[otherTileX][otherTileY] {
                            // compare the value of other tile and also check if the other tile has been merged this round
                            if (tile.value == otherTile.value && !otherTile.mergedThisRound) {
                                self.mergeTilesAtindex(currentX, y: currentY, withTileAtIndex: otherTileX, y: otherTileY);
                                movedTilesThisRound = true; // will spawn other tile
                            } else {
                                // we cannot merge so we want to perform a move
                                performMove = true;
                            }
                        }
                    } else {
                        // we cannot merge so we want to perform a move
                        performMove = true;
                    }
                    if performMove {
                        // move tile to furthest position
                        if newX != currentX || newY != currentY {
                            // only move tile if position changed
                            self.moveTile(tile, fromX: currentX, fromY: currentY, toX: newX, toY: newY);
                            movedTilesThisRound = true; // will spawn other tile
                        }
                    }
                }
                // move further in this column
                currentY += yChange;
            }
            currentX += xChange;
            currentY = initialY;
        }
        // if any movement resulted from the swipe, a random tile is spawned at a random unnocupied location.
        if (movedTilesThisRound) {
            self.spawnRandomTile();
        }
    }
    
    // actions to be called at each swipe;
    
    func swipeLeft() { // to be implemented
        self.move(CGPoint(x: -1, y: 0));
    }
    
    func swipeRight() { // to be implemented
        self.move(CGPoint(x: 1, y: 0));
    }
    
    func swipeUp() { // to be implemented
        self.move(CGPoint(x: 0, y: 1));
    }
    
    func swipeDown() { // to be implemented
        self.move(CGPoint(x: 0, y: -1));
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
    /***** END OF SWIPE METHODS *****/
    
    
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
