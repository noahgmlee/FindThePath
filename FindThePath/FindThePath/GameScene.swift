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
    var curRow:Int!
    var curCol:Int!
    var matrix:TileMatrix!
    var Player:SKSpriteNode!
    var blockSize:CGFloat!
    let screenSize = UIScreen.main.bounds
    
    override func didMove(to view: SKView) {
        matrix = TileMatrix(rows: numRows, cols: numCols)
        blockSize = screenSize.height/CGFloat(numCols)
        for row in 0..<numRows {
            if row == 0 || row == 8 {
                for col in 0..<numCols {
                    let platform = SKSpriteNode(imageNamed: "WoodPlatform")
                    platform.setScale(blockSize/64.0)
                    platform.position = gridPosition(blockSize: blockSize, row:row, col:col)
                    platform.zPosition = 2.0
                    self.addChild(platform)
                    matrix.arr[row][col].sprite = platform
                }
            }
            else {
                for col in 0..<numCols {
                    let tile = SKSpriteNode(imageNamed: "Tile")
                    tile.setScale(blockSize/64.0 * 0.9)
                    tile.position = gridPosition(blockSize: blockSize, row: row, col: col)
                    tile.zPosition = 2.0
                    self.addChild(tile)
                    matrix.arr[row][col].sprite = tile
                }
            }
        }
        matrix.createPath()
        for row in 1..<numRows-1 {
            for col in 0..<numCols{
                if matrix.arr[row][col].isPath == true{
                    matrix.arr[row][col].sprite.color = .red
                    matrix.arr[row][col].sprite.colorBlendFactor = 1
                }
            }
        }
        Player = SKSpriteNode(imageNamed: "Player")
        Player.setScale(blockSize/64.0 * 0.75)
        Player.position = gridPosition(blockSize: blockSize, row: numRows - 1, col: numCols/2)
        Player.zPosition = 3.0
        self.addChild(Player)
        curRow = numRows - 1
        curCol = numCols / 2
        initializeArrow(dir: 0, bs: blockSize)
        initializeArrow(dir: 1, bs: blockSize)
        initializeArrow(dir: 2, bs: blockSize)
        initializeArrow(dir: 3, bs: blockSize)
    }
    
    func gridPosition(blockSize:CGFloat, row:Int, col:Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        let x = CGFloat(col) * blockSize - (blockSize * CGFloat(numCols)) / 2.0 + offset
        let y = CGFloat(numRows - row - 1) * blockSize - (blockSize * CGFloat(numRows)) / 2.0 + offset
        return CGPoint(x:x, y:y)
    }
    
    func arrowPosition(xoffset: CGFloat, yoffset: CGFloat, blockSize: CGFloat, row: Int, col: Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        let x = CGFloat(col) * blockSize - (blockSize * CGFloat(numCols)) / 2.0 + offset
        let y = CGFloat(numRows - row - 1) * blockSize - (blockSize * CGFloat(numRows)) / 2.0 + offset
        return CGPoint(x:x + xoffset, y:y + yoffset)
    }
    
    func initializeArrow(dir: Int, bs: CGFloat) {
        var xoffset:CGFloat!
        var yoffset:CGFloat!
        var rotation:CGFloat!
        let arrow = SKSpriteNode(imageNamed: "arrow")
        switch dir{
        case 0:
            xoffset = bs/2.0
            yoffset = bs
            rotation = 0
            arrow.name = "up"
        case 1:
            xoffset = bs
            yoffset = bs/2.0
            rotation = 3/2
            arrow.name = "right"
        case 2:
            xoffset = 0
            yoffset = bs/2.0
            rotation = 1/2
            arrow.name = "left"
        case 3:
            xoffset = bs/2.0
            yoffset = 0
            rotation = 1.0
            arrow.name = "down"
        default:
        return
        }
        arrow.position = arrowPosition(xoffset: xoffset, yoffset: yoffset, blockSize: bs, row: numRows - 1, col: 0)
        arrow.zRotation = rotation * CGFloat.pi
        arrow.setScale(bs/64.0)
        arrow.zPosition = 3.0
        self.addChild(arrow)
    }
    
/*
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
 */
    /*
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
 */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchedNode = self.atPoint(t.location(in: self))
            if touchedNode.name == "up" {
                Player.position = gridPosition(blockSize: blockSize, row: curRow - 1, col: curCol)
                curRow = curRow - 1
            }
            else if touchedNode.name == "right" {
                Player.position = gridPosition(blockSize: blockSize, row: curRow, col: curCol + 1)
                curCol = curCol + 1
            }
            else if touchedNode.name == "left" {
                Player.position = gridPosition(blockSize: blockSize, row: curRow, col: curCol - 1)
                curCol = curCol - 1
            }
            else if touchedNode.name == "down" {
                Player.position = gridPosition(blockSize: blockSize, row: curRow + 1, col: curCol)
                curRow = curRow + 1
            }
            if matrix.arr[curRow][curCol].isPath == false {
                Player.position = gridPosition(blockSize: blockSize, row: numRows - 1, col: numCols/2)
                curRow = numRows - 1
                curCol = numCols/2
            }
        }
        /*
        let touchedNode = self.nodeAtPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "pineapple"
            {
                print("Touched")
            }
        }
        */
    }
  /*
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
