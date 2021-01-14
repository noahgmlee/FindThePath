//
//  MainMenuScene.swift
//  FindThePath
//
//  Created by Alessandro Menchetti on 2021-01-11.
//  Copyright © 2021 NoahAle. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    let playButtonLabel = SKLabelNode(fontNamed: "theboldfont")
    
    override func didMove(to view: SKView) {
        
        playButtonLabel.text = "Play"
        playButtonLabel.fontSize = 125
        playButtonLabel.position = CGPoint(x: 0, y: 0)
        playButtonLabel.zPosition = 5
        playButtonLabel.color = .white
        self.addChild(playButtonLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            let pointOfTouch = t.location(in: self)
            
            if playButtonLabel.contains(pointOfTouch) {
                
                let sceneToMoveTo = GameScene(fileNamed: "GameScene")
                sceneToMoveTo!.scaleMode = self.scaleMode
                let fadeTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo!, transition: fadeTransition)
                
            }
            
        }
        
    }
    
}
