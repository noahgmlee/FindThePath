//
//  PauseScene.swift
//  FindThePath
//
//  Created by Alessandro Menchetti on 2022-05-05.
//  Copyright © 2022 NoahAle. All rights reserved.
//

import SpriteKit

class PauseScene: SKScene {
    
    let contLabel = SKLabelNode(fontNamed: "theboldfont")
    let exitLabel = SKLabelNode(fontNamed: "theboldfont")
    
    var parentScene: SKScene?
    
    override func didMove(to view: SKView) {
        
        self.run(buttonClickSound)
        contLabel.text = "Continue"
        contLabel.fontSize = screenSize.width * 0.15 //60
        contLabel.verticalAlignmentMode = .center
        contLabel.position = CGPoint(x: 0, y: screenSize.size.height * 0.25)
        contLabel.zPosition = 500
        contLabel.color = .white
        self.addChild(contLabel)
        
        exitLabel.text = "Exit"
        exitLabel.fontSize = screenSize.width * 0.15 //60
        exitLabel.verticalAlignmentMode = .center
        exitLabel.position = CGPoint(x: 0, y: -screenSize.size.height * 0.25)
        exitLabel.zPosition = 5
        exitLabel.color = .white
        self.addChild(exitLabel)
        
        drawBackground(scene: self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            let pointOfTouch = t.location(in: self)
            
            if contLabel.contains(pointOfTouch) {
                
                if parentScene != nil {
                    
                    if let previousScene = self.parentScene {
                        self.view!.presentScene(previousScene)
                    }
                    
                }
                /*let sceneToMoveTo = parentScene
                sceneToMoveTo!.scaleMode = self.scaleMode
                sceneToMoveTo!.size = self.size
                //let fadeTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo!)/*, transition: fadeTransition)*/*/
                
            }
            
            if exitLabel.contains(pointOfTouch) {
                
                self.run(buttonClickSound)
                level = 0
                let sceneToMoveTo = MainMenuScene(fileNamed: "MainMenuScene")
                sceneToMoveTo!.scaleMode = self.scaleMode
                sceneToMoveTo!.size = self.size
                let fadeTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo!, transition: fadeTransition)
                
            }
            
            /*if playAgainLabel.contains(pointOfTouch) {
                
                let sceneToMoveTo = GameScene(fileNamed: "GameScene")
                sceneToMoveTo!.scaleMode = self.scaleMode
                sceneToMoveTo!.size = self.size
                let fadeTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo!, transition: fadeTransition)
                
            }
            else if exitLabel.contains(pointOfTouch) {
                
                let sceneToMoveTo = MainMenuScene(fileNamed: "MainMenuScene")
                sceneToMoveTo!.scaleMode = self.scaleMode
                sceneToMoveTo!.size = self.size
                let fadeTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo!, transition: fadeTransition)
                
            }*/
            
        }
        
    }
    
}

