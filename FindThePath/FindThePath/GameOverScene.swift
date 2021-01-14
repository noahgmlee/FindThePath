//
//  GameOverScene.swift
//  FindThePath
//
//  Created by Alessandro Menchetti on 2021-01-13.
//  Copyright © 2021 NoahAle. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let gameOverLabel = SKLabelNode(fontNamed: "theboldfont")
    let levelLabel = SKLabelNode(fontNamed: "theboldfont")
    let highScoreLabel = SKLabelNode(fontNamed: "theboldfont")
    let playAgainLabel = SKLabelNode(fontNamed: "theboldfont")
    let exitLabel = SKLabelNode(fontNamed: "theboldfont")
    
    override func didMove(to view: SKView) {
        
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 125
        gameOverLabel.position = CGPoint(x: 0, y: self.size.height/2 * 0.5)
        gameOverLabel.zPosition = 5
        gameOverLabel.color = .white
        self.addChild(gameOverLabel)
        
        levelLabel.text = "Level: \(level)"
        levelLabel.fontSize = 90
        levelLabel.position = CGPoint(x: 0, y: self.size.height/2 * 0.2)
        levelLabel.zPosition = 5
        levelLabel.color = .white
        self.addChild(levelLabel)
        
        let defaults = UserDefaults()
        var highScore = defaults.integer(forKey: "highScoreSaved")
        
        if level > highScore {
            highScore = level
            defaults.setValue(highScore, forKey: "highScoreSaved")
        }
        level = 0
        
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 90
        highScoreLabel.position = CGPoint(x: 0, y: 0)
        highScoreLabel.zPosition = 5
        highScoreLabel.color = .white
        self.addChild(highScoreLabel)
        
        playAgainLabel.text = "Play Again"
        playAgainLabel.fontSize = 75
        playAgainLabel.position = CGPoint(x: 0, y: -self.size.height/2 * 0.4)
        playAgainLabel.zPosition = 5
        playAgainLabel.color = .white
        self.addChild(playAgainLabel)
        
        exitLabel.text = "Exit"
        exitLabel.fontSize = 60
        exitLabel.position = CGPoint(x: 0, y: -self.size.height/2 * 0.6)
        exitLabel.zPosition = 5
        exitLabel.color = .white
        self.addChild(exitLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            let pointOfTouch = t.location(in: self)
            
            if playAgainLabel.contains(pointOfTouch) {
                
                let sceneToMoveTo = GameScene(fileNamed: "GameScene")
                sceneToMoveTo!.scaleMode = self.scaleMode
                let fadeTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo!, transition: fadeTransition)
                
            }
            else if exitLabel.contains(pointOfTouch) {
                
                let sceneToMoveTo = MainMenuScene(fileNamed: "MainMenuScene")
                sceneToMoveTo!.scaleMode = self.scaleMode
                let fadeTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo!, transition: fadeTransition)
                
            }
            
        }
        
    }
    
}
