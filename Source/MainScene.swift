import Foundation

class MainScene: CCNode {
    /* linked objects */
    
    // grid to contain tiles
    weak var grid:Grid!;
    
    // display current user score
    weak var scoreLabel:CCLabelTTF!;
    
    // display max user score
    weak var highScoreLabel:CCLabelTTF!;
}
