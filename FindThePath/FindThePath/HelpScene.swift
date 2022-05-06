//
//  HelpScene.swift
//  FindThePath
//
//  Created by Alessandro Menchetti on 2021-01-23.
//  Copyright © 2021 NoahAle. All rights reserved.
//

import SpriteKit

class HelpScene: SKScene {
    
    let helpText = SKLabelNode(fontNamed: "theboldfont")
    let controlLabel = SKLabelNode(fontNamed: "theboldfont")
    let controlsText = SKLabelNode(fontNamed: "theboldfont")
    let backLabel = SKLabelNode(fontNamed: "theboldfont")
    
    override func didMove(to view: SKView) {
        
        helpText.text = "Welcome to Frog Cross! You need to help the frog cross the pond by jumping on lily pads. Be careful, some of the lily pads are unstable and will make the frog fall into the water! Find the correct path to make it to the other side. The path can only go up, left, or right but not backwards. Find the path and cross the pond within the time limit to make it to the next level! Every time you beat a level more time is added to the clock. Good Luck!"
        helpText.numberOfLines = 16
        helpText.lineBreakMode = .byWordWrapping
        helpText.preferredMaxLayoutWidth = screenSize.width * 0.75
        //helpText.fontSize = screenSize.width * 0.15 //60
        helpText.fontSize = 20
        helpText.horizontalAlignmentMode = .center
        helpText.verticalAlignmentMode = .center
        helpText.position = CGPoint(x: 0, y: screenSize.size.height * 0.175)
        helpText.zPosition = 5
        helpText.color = .white
        self.addChild(helpText)
        
        controlLabel.text = "Controls:"
        controlLabel.fontSize = 30 //60
        controlLabel.verticalAlignmentMode = .center
        controlLabel.position = CGPoint(x: 0, y: -screenSize.size.height * 0.15)
        controlLabel.zPosition = 5
        controlLabel.color = .white
        self.addChild(controlLabel)
        
        controlsText.text = "Swipe in the direction you want to move the frog."
        controlsText.numberOfLines = 2
        controlsText.lineBreakMode = .byWordWrapping
        controlsText.preferredMaxLayoutWidth = screenSize.width * 0.75
        //helpText.fontSize = screenSize.width * 0.15 //60
        controlsText.fontSize = 20
        controlsText.horizontalAlignmentMode = .center
        controlsText.verticalAlignmentMode = .center
        controlsText.position = CGPoint(x: 0, y: -screenSize.size.height * 0.225)
        controlsText.zPosition = 5
        controlsText.color = .white
        self.addChild(controlsText)
        
        backLabel.text = "Back"
        backLabel.fontSize = screenSize.width * 0.15 //60
        backLabel.verticalAlignmentMode = .center
        backLabel.position = CGPoint(x: 0, y: -screenSize.size.height * 0.325)
        backLabel.zPosition = 5
        backLabel.color = .white
        self.addChild(backLabel)
        
        drawBackground(scene: self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            let pointOfTouch = t.location(in: self)
            
            if backLabel.contains(pointOfTouch) {
                
                self.run(buttonClickSound)
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
