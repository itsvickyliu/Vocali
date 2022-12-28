//
//  GameScene.swift
//  Technovation
//
//  Created by Vicky Liu on 3/18/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import SpriteKit
import GameplayKit
import Firebase

enum GameState {
    case showingLogo
    case playing
    case dead
    case succeed
}

class GameScene: SKScene, SKPhysicsContactDelegate, SBSpeechRecognizerDelegate, CanSpeakDelegate {
    
    let canSpeak = CanSpeak()
    let speechRecognizer = SBSpeechRecognizer()
    
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score = NSInteger()
    var logo: SKSpriteNode!
    var gameOver: SKLabelNode!
    var succeed: SKLabelNode!
    var keyWord = String()
    var keyWordLabel: SKLabelNode!
    var mode = String()

    var gameState = GameState.showingLogo
    
    let groundCategory: UInt32 = 1 << 0
    let obstacleCategory: UInt32 = 1 << 1
    let playerCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    let figureTexture19 = SKTexture(imageNamed: "frame_00019")
    let figureTexture20 = SKTexture(imageNamed: "frame_00020")
    let figureTexture24 = SKTexture(imageNamed: "frame_00024")
    
    let obstacleTexture1 = SKTexture(imageNamed: "block1")
    let obstacleTexture2 = SKTexture(imageNamed: "block2")
    
    var runForever:SKAction!
    
    override func didMove(to view: SKView) {
        self.canSpeak.delegate = self
        self.speechRecognizer.delegate = self
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
        
        createSigns()
        createPlayer()
        createSky()
        createCeiling()
        createGround()
        createScore()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .showingLogo:
            
            gameState = .playing
            
            player.physicsBody?.isDynamic = true
            createKeyWord()
            createMode()
            canSpeak.sayThis(keyWord)
            startObstacles()

        case .playing:
            
            self.isUserInteractionEnabled = false

        case .dead:
            
            self.isUserInteractionEnabled = true
            
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.userData = NSMutableDictionary()
                scene.userData?.setValue(keyWord, forKey: "keyWord")
                scene.userData?.setValue(mode, forKey: "mode")
                scene.scaleMode = .resizeFill
                let transition = SKTransition.fade(with: SKColor(red:0.63, green:0.89, blue:1.00, alpha:1.0), duration: 1)
                view?.presentScene(scene, transition: transition)
            }
            
        case .succeed:
            self.isUserInteractionEnabled = true
            
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.userData = NSMutableDictionary()
                scene.userData?.setValue(keyWord, forKey: "keyWord")
                scene.userData?.setValue(mode, forKey: "mode")
                scene.scaleMode = .resizeFill
                let transition = SKTransition.fade(with: SKColor(red:0.63, green:0.89, blue:1.00, alpha:1.0), duration: 1)
                view?.presentScene(scene, transition: transition)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == scoreCategory || contact.bodyB.categoryBitMask == scoreCategory {
            if contact.bodyA.node == player {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
            score += 1
            scoreLabel.text = String("Score: \(score)")
            scoreLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.1)), SKAction.scale(to: 1.0, duration:TimeInterval(0.1))]))
            
            if score == 5 {
                self.speechRecognizer.stopRecording()
                print("stop audio - if succeed")
                
                let show = SKAction.run { [unowned self] in
                    self.succeed.alpha = 1
                    self.gameState = .succeed
                    self.keyWordLabel.alpha = 0
                    self.speed = 0
                }
                let wait = SKAction.wait(forDuration: 0.5)
                let sequence = SKAction.sequence([wait, show])
                succeed.run (sequence)
                
                Firestore.firestore().settings = FirestoreSettings()
                let db = Firestore.firestore()
                
                //get no of points from Firestore to local storage
                let docRef = db.collection("users").document(Constants.uID!)
                
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        Constants.points = document.get("points") as? Int
                        print("Number of points from Firestore: \(String(describing: Constants.points))")
                        
                        //save points to Firestore
                        let newPoints = (Constants.points ?? 0) + 5
                        db.collection("users").document(Constants.uID!).updateData([
                            "points": newPoints
                        ]){ err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Firestore points +5, now: \(newPoints)")
                                Constants.points = newPoints
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
            return
        }
            
        else if contact.bodyA.categoryBitMask == groundCategory || contact.bodyB.categoryBitMask == groundCategory {
            if contact.bodyA.node == player || contact.bodyB.node == player {
                player.run(runForever)
            }
        }
        
        else if contact.bodyA.categoryBitMask == obstacleCategory || contact.bodyB.categoryBitMask == obstacleCategory {
            
            speechRecognizer.stopRecording()
            print("stop audio - if contact")
            
            gameOver.alpha = 1
            keyWordLabel.alpha = 0
            gameState = .dead
            speed = 0
        }
        
        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
            return
        }
    }
    
    func speechDidFinish() {
        let record = SKAction.run { [unowned self] in
            do {
                try self.speechRecognizer.startRecording(self.keyWord, self.mode)
               } catch {
                   print (error)
               }
        }
        let wait = SKAction.wait(forDuration: 0.15)
        let sequence = SKAction.sequence([wait, record])
        run (sequence)
    }
    
    func jump(){
        self.keyWordLabel.fontColor = UIColor(displayP3Red: 0.93, green: 0.455, blue: 0.38, alpha: 1)
        let anim = SKAction.animate(with: [self.figureTexture19, self.figureTexture20, self.figureTexture24], timePerFrame: 0.6)
        let waitDuration = 0.7
        let waitAction = SKAction.wait(forDuration: waitDuration)
        self.player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: self.frame.height/3))
        self.player.run(SKAction.sequence([anim, waitAction]))
        self.scoreLabel.fontColor = UIColor.black
                
        let changeColor = SKAction.run { [unowned self] in
            self.keyWordLabel.fontColor = UIColor.black
        }
        let sequence = SKAction.sequence([waitAction, changeColor])
        self.run(sequence)
    }
    
    func createMode(){
        mode = self.userData?.value(forKey: "mode") as! String
    }
    
    func createKeyWord() {
        
        keyWord = self.userData?.value(forKey: "keyWord") as! String
        
        keyWordLabel = SKLabelNode(fontNamed: "FredokaOne-Regular")
        keyWordLabel.fontSize = 60
        keyWordLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        keyWordLabel.text = String(keyWord)
        keyWordLabel.fontColor = UIColor.black
        keyWordLabel.zPosition = 30
        addChild(keyWordLabel)
    }
    
    func createSigns() {
        gameOver = SKLabelNode(fontNamed: "NanumPen")
        gameOver.fontSize = 80
        gameOver.fontColor = UIColor.black
        gameOver.text = String("Game Over")
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.alpha = 0
        gameOver.zPosition = 30
        addChild(gameOver)
        
        succeed = SKLabelNode(fontNamed: "NanumPen")
        succeed.fontSize = 80
        succeed.fontColor = UIColor.black
        succeed.text = String("Succeed")
        succeed.position = CGPoint(x: frame.midX, y: frame.midY)
        succeed.alpha = 0
        succeed.zPosition = 30
        addChild(succeed)
    }
    
    func createPlayer() {
        let playerTexture = SKTexture(imageNamed: "frame_00001")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 4, y: frame.height * 0.75)

        addChild(player)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.allowsRotation = false //check if work over time
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = groundCategory | obstacleCategory
        player.physicsBody?.contactTestBitMask = obstacleCategory | scoreCategory

        let frame2 = SKTexture(imageNamed: "frame_00002")
        let frame3 = SKTexture(imageNamed: "frame_00003")
        let frame4 = SKTexture(imageNamed: "frame_00004")
        let frame5 = SKTexture(imageNamed: "frame_00005")
        let frame6 = SKTexture(imageNamed: "frame_00006")
        let frame7 = SKTexture(imageNamed: "frame_00007")
        let frame8 = SKTexture(imageNamed: "frame_00008")
        let animation = SKAction.animate(with: [playerTexture, frame2, frame3, frame4, frame5, frame6, frame7, frame8], timePerFrame: 0.12)
        runForever = SKAction.repeatForever(animation)
        player.setScale(0.2)
        player.run(runForever)
    }
    
    func createSky() {
        let sky = SKSpriteNode(imageNamed: "background")
        sky.size = CGSize(width: frame.width, height: frame.height)
        sky.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(sky)
        sky.zPosition = -40
    }
    
    
    func createCeiling(){
        let ceil = SKSpriteNode(color: UIColor.clear, size: CGSize(width:frame.width, height: 1))
        ceil.anchorPoint = CGPoint(x:0.5, y:0.5)
        ceil.position = CGPoint(x: frame.midX, y: frame.height)
        ceil.physicsBody = SKPhysicsBody(rectangleOf: ceil.size)
        ceil.physicsBody?.categoryBitMask = groundCategory
        ceil.physicsBody?.collisionBitMask = playerCategory
        ceil.physicsBody?.affectedByGravity = false
        ceil.physicsBody?.isDynamic = false
        addChild(ceil)
    }
    
    func createGround() {
        let landTexture = SKTexture(imageNamed: "land")
        let num = Int(size.width / landTexture.size().width) + 1
        for i in 0 ... num {
            let land = SKSpriteNode(texture: landTexture)
            land.zPosition = -10
            land.position = CGPoint(x: (landTexture.size().width / 2.0 + (landTexture.size().width * CGFloat(i))), y: frame.height/7)

            addChild(land)
            
            land.physicsBody = SKPhysicsBody(rectangleOf: land.size)
            land.physicsBody?.isDynamic = false
            let moveLeft = SKAction.moveBy(x: -landTexture.size().width, y: 0, duration: 1)
            let moveReset = SKAction.moveBy(x: landTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            land.run(moveForever)
        }
        
        let ground = SKSpriteNode(color: UIColor(red:0.47, green:0.30, blue:0.28, alpha:1.0), size: CGSize(width: frame.width, height: frame.height/6))
        ground.anchorPoint = CGPoint(x: 0.5, y: 0)
        ground.position = CGPoint(x: frame.midX, y: 0)
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.collisionBitMask = playerCategory
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.affectedByGravity = false
        
        addChild(ground)
        ground.zPosition = -9
    }
    
    func createObstacles() {
        let obstacleTexture = SKTexture(imageNamed: "block1")

        let obstacle = SKSpriteNode(texture: obstacleTexture)
        obstacle.setScale(0.2)
        
        let anim = SKAction.animate(with: [obstacleTexture1, obstacleTexture2], timePerFrame: 1.75)
        let change = SKAction.repeatForever(anim)
        obstacle.run(change)
        
        obstacle.zPosition = -20

        let obstacleCollision = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 32, height: frame.height))

        addChild(obstacle)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = obstacleCategory
        obstacle.physicsBody?.collisionBitMask = playerCategory
        obstacle.physicsBody?.contactTestBitMask = playerCategory
        
        addChild(obstacleCollision)

        let xPosition = frame.width + obstacle.frame.width

        let max = CGFloat(frame.height / 3)
        let yPosition = CGFloat.random(in: frame.height/5...max)

        let obstacleDistance: CGFloat = 40

        obstacle.position = CGPoint(x: xPosition, y: yPosition - obstacleDistance)
        obstacleCollision.position = CGPoint(x: xPosition + (obstacleCollision.size.width * 2), y: frame.midY)
        obstacleCollision.physicsBody = SKPhysicsBody(rectangleOf: obstacleCollision.size)
        obstacleCollision.physicsBody?.isDynamic = false
        obstacleCollision.physicsBody?.categoryBitMask = scoreCategory
        obstacleCollision.physicsBody?.contactTestBitMask = playerCategory

        let endPosition = frame.width + (obstacle.frame.width * 2)

        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 3.5)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        
        obstacle.run(moveSequence)
        obstacleCollision.run(moveSequence)
    }
    
    func startObstacles() {
        
        let create = SKAction.run { [unowned self] in
            self.createObstacles()
        }
        let wait = SKAction.wait(forDuration: TimeInterval(Int.random(in: 4..<6)), withRange: 2)
        let sequence = SKAction.sequence([wait,create])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
    
    func createScore() {
        score = 0
        scoreLabel = SKLabelNode(fontNamed: "NanumPen")
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - frame.height/10)
        scoreLabel.text = String("Score: \(score)")
        scoreLabel.fontColor = UIColor.black
        scoreLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.1)), SKAction.scale(to: 1.0, duration:TimeInterval(0.1))]))

        addChild(scoreLabel)
    }
}
