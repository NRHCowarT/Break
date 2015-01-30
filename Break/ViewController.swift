//
//  ViewController.swift
//  Break
//
//  Created by Nick Cowart on 1/28/15.
//  Copyright (c) 2015 Nick Cowart. All rights reserved.
//

import UIKit

// Homework

// - don't reset lives to 3 if going to new level
// - make the ball a UIImageView and find an image to set it as 
//                      change ball behavior to UIImageView and any where else ball is a UIView

// - add at least 10 more levels
// - add labels in storyboard, that will be hidden during gameplay
//  these will show up at the end of the level
//  they will have the score, lives lost, bricks broken and levels passed

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var livesView: LivesView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var scoreTotalLabel: UILabel!
    @IBOutlet weak var levelsPassedLabel: UILabel!
    @IBOutlet weak var livesLostLabel: UILabel!
    @IBOutlet weak var bricksBrokenLabel: UILabel!
    
    var score: Int = 0 {
        
        didSet {
            
            if score > GameData.mainData().topScore{ GameData.mainData().topScore = score }
            
            GameData.mainData().currentGame?["totalScore"] = score
        
            println(GameData.mainData().currentGame)
            
            scoreLabel.text = "\(score)"
//                              ^^^^^^^ putting a variable into a string
        }
    }
    
    var animator : UIDynamicAnimator?
    
    var gravityBehavior = UIGravityBehavior()
    var collisionBehavior = UICollisionBehavior()
    var ballBehavior = UIDynamicItemBehavior()
    var brickBehavior = UIDynamicItemBehavior()
    var paddleBehavior = UIDynamicItemBehavior()
    
    var paddle = UIView(frame: CGRectMake(0, 0, 100, 10))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: gameView)
    
        animator?.addBehavior(gravityBehavior)
        animator?.addBehavior(collisionBehavior)
        animator?.addBehavior(ballBehavior)
        animator?.addBehavior(brickBehavior)
        animator?.addBehavior(paddleBehavior)
        
//        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionDelegate = self
        
        collisionBehavior.addBoundaryWithIdentifier("ceiling", fromPoint: CGPointZero, toPoint: CGPointMake(SCREEN_WIDTH, 0))
        
        collisionBehavior.addBoundaryWithIdentifier("leftWall", fromPoint: CGPointZero, toPoint: CGPointMake(0, SCREEN_HEIGHT))
        
        collisionBehavior.addBoundaryWithIdentifier("rightWall", fromPoint: CGPointMake(SCREEN_WIDTH, 0), toPoint: CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT))
        
        collisionBehavior.addBoundaryWithIdentifier("lava", fromPoint: CGPointMake(0, SCREEN_HEIGHT - 30), toPoint: CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT - 30))
        
        println(collisionBehavior.boundaryIdentifiers)
        
        ballBehavior.friction = 0
        ballBehavior.elasticity = 1
        ballBehavior.resistance = 0
        ballBehavior.allowsRotation = false
        
        brickBehavior.density = 1000000
        
        paddleBehavior.density = 1000000
        
        paddleBehavior.allowsRotation = false
        

    
        // Do any additional setup after loading the view, typically from a nib.
  }
    
    @IBAction func playGame() {
        
        GameData.mainData().startGame()
        
        titleLabel.hidden = true
        playButton.hidden = true
        bricksBrokenLabel.hidden = true
        livesLostLabel.hidden = true
        levelsPassedLabel.hidden = true
        scoreTotalLabel.hidden = true
        
        
        
//        if GameData.mainData().currentLevel == 0 {
//        ^^^^^ this line is same as the next 2 lines below.

        if GameData.mainData().currentLevel > 0 {
            
        } else {
            
            score = 0
            livesView.livesLeft = 3
            
        }
        
       
        
        
        
        createPaddle()
        createBall()
        createBricks()
    
    }
    
    func endGame(gameOver: Bool)  {
        
        if gameOver {
            
            GameData.mainData().currentLevel = 0
            
            
        
        }
        
        GameData.mainData().currentLevel =  gameOver ? 0 : ++GameData.mainData().currentLevel
        
//        GameData.mainData().currentLevel = gameOver ? 0 :
        
        println(GameData.mainData().currentLevel)
        
        
        println(GameData.mainData().gamesPlayed)
        println(GameData.mainData().topScore)
        
        titleLabel.hidden = false
        playButton.hidden = false
        bricksBrokenLabel.hidden = false
        livesLostLabel.hidden = false
        levelsPassedLabel.hidden = false
        scoreTotalLabel.hidden = false
        
        var livesLost = GameData.mainData().currentGame!["livesLost"]! as Int
        var bricksBroken = GameData.mainData().currentGame!["bricksBusted"]! as Int
        
        
        scoreTotalLabel.text = "Score Total: \(score)"
        livesLostLabel.text  = "Lives Lost: \(livesLost)"
        bricksBrokenLabel.text = "Bricks Broken: \(bricksBroken)"
        levelsPassedLabel.text = "Level Passed: \(GameData.mainData().currentLevel)"
        
        
        
//        remove paddle
        
        paddle.removeFromSuperview()
        collisionBehavior.removeItem(paddle)
        paddleBehavior.removeItem(paddle)
        
//        remove ball
        
        for ball in ballBehavior.items as [UIImageView] {
//            ask Joe question about this line ^^^
            ball.removeFromSuperview()
            collisionBehavior.removeItem(ball)
            ballBehavior.removeItem(ball)
        }
        
//        remove bricks
        
        for brick in brickBehavior.items as [UIView] {

            brick.removeFromSuperview()
            collisionBehavior.removeItem(brick)
            brickBehavior.removeItem(brick)
            
        }
    
    }

    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        
        ballBehavior.items
        brickBehavior.items
        
        for brick in brickBehavior.items as [UIView] {
            
            if brick.isEqual(item1) || brick.isEqual(item2) {
                
                collisionBehavior.removeItem(brick)
                brickBehavior.removeItem(brick)
                brick.removeFromSuperview()
                
                score += 100
                
                GameData.mainData().adjustValue(1, forKey: "bricksBusted")

                var pointsLabel = UILabel(frame: brick.frame)
                pointsLabel.text = "+100"
                pointsLabel.textAlignment = .Center
                
                gameView.addSubview(pointsLabel)
                
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    pointsLabel.alpha = 0
                    
                }, completion: { (succeeded) -> Void in
                    
                    pointsLabel.removeFromSuperview()
                })
            }
        }
        
        if brickBehavior.items.count == 0 {
            
            endGame(false)
            
            
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        
        if let id = identifier as? String {

            if identifier as String == "lava" {
            
                var ball = item as UIImageView
                
                collisionBehavior.removeItem(ball)
                ballBehavior.removeItem(ball)
                
                ball.removeFromSuperview()
                
                if livesView.livesLeft == 0 { endGame(true); return}
                
//                var ll = GameData.mainData().currentGame?["livesLost"] + 1
//
//                GameData.mainData().currentGame?["livesLost"] = ll
                
                GameData.mainData().adjustValue(1, forKey: "livesLost")
                
                livesView.livesLeft--
                
                createBall()
            
            }
            
        }
        
    }
    
    func createBall(){

        var ball = UIImageView(frame: CGRectMake(0, 0, 20, 20))
        
        ball.image = UIImage(named: "SadFace")

        ball.center.x = paddle.center.x
        ball.center.y = paddle.center.y - 40
        
        ball.backgroundColor = UIColor.blackColor()
        ball.layer.cornerRadius = 10
        ball.layer.masksToBounds = true
        
        gameView.addSubview(ball)
        
//        gravityBehavior.addItem(ball)
        
        collisionBehavior.addItem(ball)
        ballBehavior.addItem(ball)
        
        var pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        
        pushBehavior.pushDirection = CGVectorMake(0.06, -0.06)
        
        animator?.addBehavior(pushBehavior)

    }
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
    
    func createBricks(){
        
        var grid = GameData.mainData().allLevels[GameData.mainData().currentLevel]
        
        var gap: CGFloat = 10
        var width = (SCREEN_WIDTH - (gap * CGFloat(grid.0 + 1))) / CGFloat(grid.0)
        var height: CGFloat = 20
        
        for c in 0..<grid.0 {
            
            for r in 0..<grid.1 {
                
                var x = CGFloat(c) * (width + gap) + gap
                var y = CGFloat(r) * (height + gap) + 70
                
                var brick = UIView(frame: CGRectMake(x, y, width, height))
                
                brick.backgroundColor = UIColor.blackColor()
                brick.layer.cornerRadius = 3
                
                gameView.addSubview(brick)
                
                collisionBehavior.addItem(brick)
                
                brickBehavior.addItem(brick)
                
                
            }
        }
        
    }
    
    var attachmentBehavior: UIAttachmentBehavior?

    func createPaddle() {
        
        paddle.center.x = view.center.x
        paddle.center.y = SCREEN_HEIGHT - 40
        paddle.backgroundColor = UIColor.blackColor()
        paddle.layer.cornerRadius = 3
        
        gameView.addSubview(paddle)
        
        collisionBehavior.addItem(paddle)
        paddleBehavior.addItem(paddle)
        
        
        if attachmentBehavior == nil {
            
            attachmentBehavior = UIAttachmentBehavior(item: paddle, attachedToAnchor: paddle.center)
            animator?.addBehavior(attachmentBehavior)
            
        }

        
    }
    
    
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if let touch = touches.allObjects.first as? UITouch{
            
            let location = touch.locationInView(gameView)
            
//            paddle.center.x = location.x
            attachmentBehavior?.anchorPoint.x = location.x
        }
    }
    
}






