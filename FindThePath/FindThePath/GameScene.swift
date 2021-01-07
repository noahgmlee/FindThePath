//
//  GameScene.swift
//  FindThePath
//
//  Created by Noah Lee on 2021-01-06.
//  Copyright © 2021 NoahAle. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
 //   private var label : SKLabelNode?
 //   private var spinnyNode : SKShapeNode?
    var numRows = 9
    var numCols = 5
    var arr:[[SKSpriteNode]]?// = [[SKSpriteNode]](repeating: [SKSpriteNode](repeating: SKSpriteNode.init(), count: numCols), count: numRows)
    let screenSize = UIScreen.main.bounds
    
    override func didMove(to view: SKView) {
        if let grid = Grid(blockSize: screenSize.height/CGFloat(numCols), rows:numRows, cols:numCols) {
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            addChild(grid)
            makeArray()
            for row in 0..<numRows {
                if row == 0 || row == 8 {
                    for col in 0..<numCols {
                        let platform = SKSpriteNode(imageNamed: "WoodPlatform")
                        platform.setScale(grid.blockSize/64.0)
                        platform.position = grid.gridPosition(row:row, col:col)
                        grid.addChild(platform)
                        arr![row][col] = platform
                    }
                }
                else {
                    for col in 0..<numCols {
                        let tile = SKSpriteNode(imageNamed: "Tile")
                        tile.setScale(grid.blockSize/64.0 * 0.75)
                        tile.position = grid.gridPosition(row: row, col: col)
                        grid.addChild(tile)
                        arr![row][col] = tile
                    }
                }
            }
     
            let path = PathArray(rows: numRows, cols: numCols)
            path.createPath()
            for row in 1..<numRows-1 {
                for col in 0..<numCols{
                    if path.arr![row][col].isPath == true{
                        arr![row][col].color = .red
                        arr![row][col].colorBlendFactor = 1
                    }
                }
            }
        }
    }
    
    func makeArray(){
        arr = [[SKSpriteNode]](repeating: [SKSpriteNode](repeating: SKSpriteNode(), count: numCols), count: numRows)
    }
    
/*
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
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
 */
}
