//
//  GameScene.swift
//  Breakout
//
//  Created by Valdez, Armando Anthony on 11/29/20.
//
// image from flaticon.com
// Icons made by <a href="https://www.flaticon.com/authors/smartline" title="Smartline">Smartline</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>




import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var ball = SKSpriteNode()
    var paddle = SKSpriteNode()
    var block = SKSpriteNode()
    var floor = SKSpriteNode()
    var ceiling = SKSpriteNode()
    var rightWall = SKSpriteNode()
    var leftWall = SKSpriteNode()
    
    enum NodeCategory: UInt32 {
        case ball = 1 // 0001
        case walls = 2 // 0010
        case block = 4 // 0100// 1000
        case paddle = 8
    }
    
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
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
    
        //ball.physicsBody
        ball = SKSpriteNode(imageNamed: "tennis" )
        ball.size = CGSize(width: 100, height: 100)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height/2)
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.categoryBitMask = NodeCategory.ball.rawValue
        ball.physicsBody?.contactTestBitMask = NodeCategory.block.rawValue
        ball.physicsBody?.collisionBitMask = NodeCategory.walls.rawValue | NodeCategory.paddle.rawValue
        ball.physicsBody?.allowsRotation = true
        addChild(ball)
        
        floor = SKSpriteNode(color: .blue, size: CGSize(width: self.frame.width, height: 100.0))
        floor.position = CGPoint(x: self.frame.midX, y: self.frame.minY + floor.size.height / 2)
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: floor.size.width, height: floor.size.height))
        floor.physicsBody?.isDynamic = false // so our floor doesn't move
        floor.physicsBody?.categoryBitMask = NodeCategory.walls.rawValue
        addChild(floor)
        
        
        
        rightWall = SKSpriteNode(color: .blue, size: CGSize(width: 30, height: self.frame.height * 2))
        rightWall.position = CGPoint(x: self.frame.maxX, y: self.frame.minY)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rightWall.size.width, height: rightWall.size.height))
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.categoryBitMask = NodeCategory.walls.rawValue
        addChild(rightWall)
        
        leftWall = SKSpriteNode(color: .blue, size: CGSize(width: 30, height: self.frame.height * 2))
        leftWall.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leftWall.size.width, height: leftWall.size.height))
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = NodeCategory.walls.rawValue
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
        paddle.physicsBody?.restitution = 1
        paddle.physicsBody?.allowsRotation = true
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.categoryBitMask = NodeCategory.paddle.rawValue
        //paddle.physicsBody?.contactTestBitMask = NodeCategory.wa
        paddle.physicsBody?.collisionBitMask = NodeCategory.walls.rawValue
        addChild(paddle)
        
        
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
        
        
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        //let previousLocation = touch!.previousLocation(in: self)

        //let paddle = childNode(withName: "paddle") as! SKSpriteNode
            // 4
        //let paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            // 5
        //paddleX = max(paddleX, size.width/2)
        //paddleX = min(paddleX, size.width)
        // 6
        paddle.position = CGPoint(x: touchLocation.x, y: paddle.position.y)
        paddle.physicsBody?.applyImpulse(CGVector(dx: 300, dy: 300))
        
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
