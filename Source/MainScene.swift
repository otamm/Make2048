import Foundation

class MainScene: CCNode {
    /* linked objects */
    
    // grid to contain tiles
    weak var grid:Grid!;
    
    // display current user score
    weak var scoreLabel:CCLabelTTF!;
    
    // display max user score
    weak var highScoreLabel:CCLabelTTF!;
    
    /* custom methods */
    func updateHighscore() {
        var newHighscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore"); // accesses value at "highscore" index
        self.highScoreLabel.string = "\(newHighscore)";
    }
    
    /* cocos2d methods */
    func didLoadFromCCB() {
        NSUserDefaults.standardUserDefaults().addObserver(self, forKeyPath: "highscore", options: .allZeros, context: nil); // adds observer so whenever the value stored at "highscore" index changes, a specific action to once again update highScoreLabel is called
        self.updateHighscore(); // updates highScoreLabel when game is loaded.
    }
    
    // triggered by restart button. Reloads main scene, restarting the game.  Updates highScore if that's the case.
    func restart() {
        var mainScene = CCBReader.loadAsScene("MainScene");
        CCDirector.sharedDirector().presentScene(mainScene);
    }
    
    /* iOS methods */
    
    // method is called whenever an observed object signalizes a change.
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "highscore" {
            self.updateHighscore(); 
        }
    }
}
