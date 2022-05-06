//
//  MainMenuScene.swift
//  FindThePath
//
//  Created by Alessandro Menchetti on 2021-01-11.
//  Copyright © 2021 NoahAle. All rights reserved.
//

import SpriteKit

let buttonClickSound = SKAction.playSoundFileNamed("ButtonClickSound.mp3", waitForCompletion: false)
let jumpSound = SKAction.playSoundFileNamed("JumpSound.mp3", waitForCompletion: false)
let splashSound = SKAction.playSoundFileNamed("SplashSound.mp3", waitForCompletion: false)

func drawBackground(scene:SKScene) {
    let size = CGFloat(280.0)
    let bgCols = Int(scene.size.width/size) + 1
    let bgRows = Int(scene.size.height/size) + 1
    
    print(bgCols)
    for row in 0..<bgRows {
        for col in 0..<bgCols {
            let bgTile = SKSpriteNode(imageNamed: "bg_tile")
            bgTile.setScale(1)
            bgTile.position = bgGridPosition(blockSize: size, bgRows: bgRows, bgCols: bgCols, row: row, col: col)
            bgTile.zPosition = 1.0
            scene.addChild(bgTile)
        }
    }
}

func bgGridPosition(blockSize:CGFloat, bgRows:Int, bgCols:Int, row:Int, col:Int) -> CGPoint {
    let offset = blockSize / 2.0 + 0.5
    let x = CGFloat(col) * blockSize - (blockSize * CGFloat(bgCols)) / 2.0 + offset
    let y = CGFloat(bgRows - row - 1) * blockSize - (blockSize * CGFloat(bgRows)) / 2.0 + offset
    return CGPoint(x:x, y:y)
}

class MainMenuScene: SKScene {
    
    let playButtonLabel = SKLabelNode(fontNamed: "theboldfont")
    let helpButtonLabel = SKLabelNode(fontNamed: "theboldfont")
    let frogLilyPad = SKSpriteNode(imageNamed: "FrogLilypad")
    let playLilyPad = SKSpriteNode(imageNamed: "lilypad_green")
    let helpLilyPad = SKSpriteNode(imageNamed: "lilypad_green")
    let rotate = SKAction.rotate(byAngle: 360 * CGFloat.pi / 180, duration: 5)
    
    override func didMove(to view: SKView) {
        
        print(screenSize.width)
        
        frogLilyPad.position = CGPoint(x: 0, y: screenSize.size.height * 0.3)
        frogLilyPad.zPosition = 4
        frogLilyPad.setScale(screenSize.width * 0.00036) //0.15
        self.addChild(frogLilyPad)
        
        playLilyPad.position = CGPoint(x: 0, y: 0)
        playLilyPad.zPosition = 4
        playLilyPad.setScale(screenSize.width * 0.0024) //1
        self.addChild(playLilyPad)
        
        helpLilyPad.position = CGPoint(x: 0, y: -screenSize.size.height * 0.3)
        helpLilyPad.zPosition = 4
        helpLilyPad.zRotation = 235
        helpLilyPad.setScale(screenSize.width * 0.0014) //0.6
        self.addChild(helpLilyPad)
        
        let rotateForever = SKAction.repeatForever(rotate)
        playLilyPad.run(rotateForever)
        helpLilyPad.run(rotateForever)
        
        playButtonLabel.text = "Play"
        playButtonLabel.fontSize = screenSize.width * 0.15 //60
        playButtonLabel.verticalAlignmentMode = .center
        playButtonLabel.position = playLilyPad.position
        playButtonLabel.zPosition = 5
        playButtonLabel.color = .white
        self.addChild(playButtonLabel)
        
        helpButtonLabel.text = "Help"
        helpButtonLabel.fontSize = screenSize.width * 0.07 //30
        helpButtonLabel.verticalAlignmentMode = .center
        helpButtonLabel.position = helpLilyPad.position
        helpButtonLabel.zPosition = 5
        helpButtonLabel.color = .white
        self.addChild(helpButtonLabel)
        
        drawBackground(scene: self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            let pointOfTouch = t.location(in: self)
            
            if playLilyPad.contains(pointOfTouch) {
                
                self.run(buttonClickSound)
                let sceneToMoveTo = GameScene(fileNamed: "GameScene")
                sceneToMoveTo!.scaleMode = self.scaleMode
                sceneToMoveTo!.size = self.size
                let fadeTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo!, transition: fadeTransition)
                
            }
            
            if helpLilyPad.contains(pointOfTouch) {
                
                self.run(buttonClickSound)
                let sceneToMoveTo = HelpScene(fileNamed: "HelpScene")
                sceneToMoveTo!.scaleMode = self.scaleMode
                sceneToMoveTo!.size = self.size
                let fadeTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo!, transition: fadeTransition)
                
            }
            
        }
        
    }
    
}
