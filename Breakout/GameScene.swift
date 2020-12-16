//
//  GameScene.swift
//  Breakout
//
//  Created by Valdez, Armando Anthony on 11/29/20.
//
// image from flaticon.com
// Icons made by <a href="https://www.flaticon.com/authors/smartline" title="Smartline">Smartline</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>
//Icons made by <a href="https://www.flaticon.com/authors/alfredo-hernandez" title="Alfredo Hernandez">Alfredo Hernandez</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>
// Icons made by <a href="https://www.flaticon.com/authors/vitaly-gorbachev" title="Vitaly Gorbachev">Vitaly Gorbachev</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>

//Icons made by <a href="http://www.freepik.com/" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>

//Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>

// Icons made by <a href="https://www.flaticon.com/authors/pixel-perfect" title="Pixel perfect">Pixel perfect</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>

//Icons made by <a href="https://flat-icons.com/" title="Flat Icons">Flat Icons</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>


import SpriteKit
import GameplayKit
import FirebaseDatabase
import FirebaseAuth

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var gameViewController: UIViewController?
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var pause = SKSpriteNode()
    var home = SKSpriteNode()
    var home2 = SKSpriteNode()
    var resume = SKSpriteNode()
    var restart = SKSpriteNode()
    var ball = SKSpriteNode()
    var paddle = SKSpriteNode()
    //var block = SKSpriteNode()
    var floor = SKSpriteNode()
    var ceiling = SKSpriteNode()
    var rightWall = SKSpriteNode()
    var leftWall = SKSpriteNode()
    
    var numBlocks: Int = 0
    var score: Int = 0
    var totalBlocks = 0
    
    enum NodeCategory: UInt32 {
        case ball = 1 // 0001
        case walls = 2 // 0010
        case block = 4 // 0100// 1000
        case paddle = 8
        case bottom = 16
    }
    
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        self.physicsWorld.contactDelegate = self
        //creates the boundaries
        //let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        // 2
        //borderBody.friction = 0
        // 3
        //self.physicsBody = borderBody
        setupNodes()
    }
    
    
    
    func setupNodes() {
        print("in setup")
        print("width \(self.frame.width), height \(self.frame.height)")
        
        pause = SKSpriteNode(imageNamed: "pause-button")
        pause.position = CGPoint(x: self.frame.maxX - 75, y: self.frame.maxY - 50)
        pause.size = CGSize(width: 70, height: 70)
        addChild(pause)
        
        resume = SKSpriteNode(imageNamed: "play")
        resume.position = CGPoint(x: self.frame.maxX / 2, y: 0)
        resume.size = CGSize(width: 200, height: 200)
        
        home = SKSpriteNode(imageNamed: "left-arrow")
        home.position = CGPoint(x: self.frame.maxX / -2, y: 0)
        home.size = CGSize(width: 200, height: 200)
        
        restart = SKSpriteNode(imageNamed: "arrows")
        restart.position = CGPoint(x: 0, y: self.frame.maxY / -3)
        restart.size = CGSize(width: 200, height: 200)
        
        home2 = SKSpriteNode(imageNamed: "left-arrow")
        home2.position = CGPoint(x: 0, y: self.frame.maxY / 3)
        home2.size = CGSize(width: 200, height: 200)
        
        
    
        ball = SKSpriteNode(imageNamed: "fitness-ball" )
        ball.size = CGSize(width: 100, height: 100)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height/2)
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.categoryBitMask = NodeCategory.ball.rawValue
        ball.physicsBody?.contactTestBitMask = NodeCategory.block.rawValue | NodeCategory.paddle.rawValue | NodeCategory.walls.rawValue | NodeCategory.bottom.rawValue
        ball.physicsBody?.collisionBitMask = NodeCategory.walls.rawValue | NodeCategory.paddle.rawValue | NodeCategory.block.rawValue | NodeCategory.bottom.rawValue
        ball.physicsBody?.allowsRotation = true
        addChild(ball)
        
        floor = SKSpriteNode(color: .blue, size: CGSize(width: self.frame.width, height: 100.0))
        floor.position = CGPoint(x: self.frame.midX, y: self.frame.minY + floor.size.height / 2)
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: floor.size.width, height: floor.size.height))
        floor.physicsBody?.isDynamic = false // so our floor doesn't move
        floor.physicsBody?.categoryBitMask = NodeCategory.bottom.rawValue
        addChild(floor)
        
        
        rightWall = SKSpriteNode(color: .blue, size: CGSize(width: 30, height: self.frame.height * 2))
        rightWall.position = CGPoint(x: self.frame.maxX, y: self.frame.minY)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rightWall.size.width, height: rightWall.size.height))
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.friction = 0
        rightWall.physicsBody?.categoryBitMask = NodeCategory.walls.rawValue
        rightWall.physicsBody?.restitution = 0.2
        addChild(rightWall)
        
        leftWall = SKSpriteNode(color: .blue, size: CGSize(width: 30, height: self.frame.height * 2))
        leftWall.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leftWall.size.width, height: leftWall.size.height))
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = NodeCategory.walls.rawValue
        leftWall.physicsBody?.restitution = 0.2
        addChild(leftWall)
        
        ceiling = SKSpriteNode(color: .blue, size: CGSize(width: self.frame.width, height: 100.0))
        ceiling.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - ceiling.size.height / 2)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ceiling.size.width, height: ceiling.size.height))
        ceiling.physicsBody?.isDynamic = false // so our ceiling doesn't move
        ceiling.physicsBody?.categoryBitMask = NodeCategory.walls.rawValue
        addChild(ceiling)
        
        paddle = SKSpriteNode(color: .red, size: CGSize(width: 250, height: 40))
        paddle.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 200)
        paddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: paddle.size.width, height: paddle.size.height))
        paddle.physicsBody?.friction = 0
        paddle.physicsBody?.angularDamping = 0
        paddle.physicsBody?.linearDamping = 0
        paddle.physicsBody?.restitution = 0.7
        paddle.physicsBody?.allowsRotation = true
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.categoryBitMask = NodeCategory.paddle.rawValue
        paddle.physicsBody?.contactTestBitMask = NodeCategory.walls.rawValue
        paddle.physicsBody?.collisionBitMask = NodeCategory.walls.rawValue
        addChild(paddle)
        
        numBlocks = 4
        totalBlocks = 12
        score = 0
        
        for i in 0 ..< numBlocks {
            let block = SKSpriteNode(color: .yellow, size: CGSize(width: 100, height: 100))
            block.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: block.size.width, height: block.size.height))
            block.position = CGPoint(x: self.frame.minX + 80 + CGFloat((i) * 200), y: self.frame.maxY / 4)
            block.physicsBody?.isDynamic = false
            block.physicsBody?.restitution = 1
            block.physicsBody?.categoryBitMask = NodeCategory.block.rawValue
            block.physicsBody?.contactTestBitMask = NodeCategory.ball.rawValue
            addChild(block)
        }
        
        for i in 0 ..< numBlocks {
            let block = SKSpriteNode(color: .yellow, size: CGSize(width: 100, height: 100))
            block.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: block.size.width, height: block.size.height))
            block.position = CGPoint(x: self.frame.minX + 80 + CGFloat((i) * 200), y: self.frame.maxY - 350)
            block.physicsBody?.isDynamic = false
            block.physicsBody?.restitution = 1
            block.physicsBody?.categoryBitMask = NodeCategory.block.rawValue
            block.physicsBody?.contactTestBitMask = NodeCategory.ball.rawValue
            addChild(block)
        }
        
        for i in 0 ..< numBlocks {
            let block = SKSpriteNode(color: .yellow, size: CGSize(width: 100, height: 100))
            block.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: block.size.width, height: block.size.height))
            block.position = CGPoint(x: self.frame.minX + 80 + CGFloat((i) * 200), y: self.frame.maxY - 200)
            block.physicsBody?.isDynamic = false
            block.physicsBody?.restitution = 1
            block.physicsBody?.categoryBitMask = NodeCategory.block.rawValue
            block.physicsBody?.contactTestBitMask = NodeCategory.ball.rawValue
            addChild(block)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("in did begin")
        if contact.bodyA.categoryBitMask == NodeCategory.block.rawValue || contact.bodyB.categoryBitMask == NodeCategory.block.rawValue {
            print("ball has contact with a block")
            contact.bodyA.categoryBitMask == NodeCategory.block.rawValue ? contact.bodyA.node?.removeFromParent() : contact.bodyB.node?.removeFromParent()
            ball.physicsBody?.applyImpulse(CGVector(dx: 4, dy: 0))
            totalBlocks -= 1
            score += 1
            print(score)
            if totalBlocks == 0 {
                self.isPaused = true
                addChild(home2)
                addChild(restart)
                let uid = Auth.auth().currentUser?.uid
                Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
                    let dictionary = snapshot.value as? NSDictionary
                    let oldScore = dictionary?["points"] as? Int ?? 0
                    let newScore = self.score + oldScore
                    Database.database().reference().child("users/\(uid!)/points").setValue(newScore)
                }
            }
        }
        if contact.bodyA.categoryBitMask == NodeCategory.paddle.rawValue || contact.bodyB.categoryBitMask == NodeCategory.paddle.rawValue {
                print("ball has contact with a paddle")
            ball.physicsBody?.applyImpulse(CGVector(dx:0, dy: 10))
        }
        if contact.bodyA.categoryBitMask == NodeCategory.walls.rawValue || contact.bodyB.categoryBitMask == NodeCategory.walls.rawValue {
                print("ball has contact with a wall")
            ball.physicsBody?.applyImpulse(CGVector(dx: 30, dy: 2))
        }
        if contact.bodyA.categoryBitMask == NodeCategory.bottom.rawValue || contact.bodyB.categoryBitMask == NodeCategory.bottom.rawValue {
                print("ball has contact with bottom")
            self.isPaused = true
            addChild(home2)
            addChild(restart)
        }
        
    }
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if let label = self.label {
         //   label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        //}
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        //paddle = childNode(withName: "paddle")?.name
        print("start touch")
            
        if let body = physicsWorld.body(at: touchLocation) {
            if body.node!.name == "paddle" {
                print("Began touch on paddle")
            }
        }
        
        if pause.contains(touchLocation){
            self.isPaused = true
            addChild(resume)
            addChild(home)
        }
        
        if resume.contains(touchLocation){
            resume.removeFromParent()
            home.removeFromParent()
            restart.removeFromParent()
            self.isPaused = false
        }
        
        if home.contains(touchLocation){
            print("In home touch")
            if let nav = self.view?.window?.rootViewController as? UINavigationController
            {
                nav.popViewController(animated: true)
            }
        }
        
        if home2.contains(touchLocation){
            print("In home touch")
            if let nav = self.view?.window?.rootViewController as? UINavigationController
            {
                nav.popViewController(animated: true)
            }
        }
        
        
        if restart.contains(touchLocation){
            self.removeAllChildren()
            setupNodes()
            self.isPaused = false
        }
        
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        paddle.position = CGPoint(x: touchLocation.x, y: paddle.position.y)
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
