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
    
    var numRows = 9
    var numCols = 5
    
    var level = 0
    var inLevel = false
    
    var curRow:Int!
    var curCol:Int!
    var maxIndex = 0
    var matrix:TileMatrix!
    var travelledPath = Set<Index>()
    
    var Player:SKSpriteNode!
    let fadeIn = SKAction.fadeIn(withDuration: 5)
    let fadeOut = SKAction.fadeOut(withDuration: 5)
    
    var startOfTouch:CGPoint!
    var endOfTouch:CGPoint!
    
    var blockSize:CGFloat!
    let screenSize = UIScreen.main.bounds
    
    override func didMove(to view: SKView) {
        
        blockSize = screenSize.height/CGFloat(numCols) //this will be deleted when we have set sized sprites
        Player = SKSpriteNode(imageNamed: "Player")
        Player.setScale(blockSize/64.0 * 0.75)
        Player.position = gridPosition(blockSize: blockSize, row: numRows - 1, col: numCols/2)
        Player.zPosition = 3.0
        self.addChild(Player)
        curRow = numRows - 1
        curCol = numCols / 2
        
        startNewLevel()
    }
    
    func drawGrid(_ numRows:Int, _ numCols:Int) {
        
        blockSize = screenSize.height/CGFloat(numCols)
        matrix = TileMatrix(rows: numRows, cols: numCols)
        for row in 0..<numRows {
            if row == 0 || row == numRows - 1 {
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
        
    }
    
    func hideGrid() {
        let deleteTile = SKAction.removeFromParent()
        for row in 0..<numRows {
            for col in 0..<numCols {
                matrix.arr[row][col].sprite.run(deleteTile)
            }
        }
    }
    
    func startNewLevel() {
        level += 1
        print("Level: \(level)")
        if level % 5 == 0 {
            numRows += 2
            numCols += 2
        }
        drawGrid(numRows, numCols)
        inLevel = true
    }
    
    func endLevel() {
        inLevel = false
        hideGrid()
        clearTravelledPath()
        startNewLevel()
    }
    
    func gridPosition(blockSize:CGFloat, row:Int, col:Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        let x = CGFloat(col) * blockSize - (blockSize * CGFloat(numCols)) / 2.0 + offset
        let y = CGFloat(numRows - row - 1) * blockSize - (blockSize * CGFloat(numRows)) / 2.0 + offset
        return CGPoint(x:x, y:y)
    }
    
    func movePlayer(_ dir:String) {
        switch dir {
        case "up":
            if curRow > 0 {
                if matrix.arr[curRow - 1][curCol].isPath == true {
                    let movePlayerUp = SKAction.move(to: gridPosition(blockSize: blockSize, row: curRow - 1, col: curCol), duration: 0.1)
                    if curRow - 1 == 0 {
                        let playerEndLvlSequence = SKAction.sequence([movePlayerUp, SKAction.wait(forDuration: 1), SKAction.run(movePlayerToStart), SKAction.run(endLevel)])
                        Player.run(playerEndLvlSequence)
                    }
                    else {
                        Player.run(movePlayerUp)
                        curRow = curRow - 1
                    }
                }
                else {
                    movePlayerToStart()
                }
            }
        case "left":
            if curCol > 0 {
                if matrix.arr[curRow][curCol - 1].isPath == true {
                    let movePlayerLeft = SKAction.move(to: gridPosition(blockSize: blockSize, row: curRow, col: curCol - 1), duration: 0.1)
                    Player.run(movePlayerLeft)
                    curCol = curCol - 1
                }
                else {
                    movePlayerToStart()
                }
            }
        case "down":
            if curRow < numRows - 1 {
                if matrix.arr[curRow + 1][curCol].isPath == true {
                    let movePlayerDown = SKAction.move(to: gridPosition(blockSize: blockSize, row: curRow + 1, col: curCol), duration: 0.1)
                    Player.run(movePlayerDown)
                    curRow = curRow + 1
                }
                else {
                    movePlayerToStart()
                }
            }
        case "right":
            if curCol < numCols - 1 {
                if matrix.arr[curRow][curCol + 1].isPath == true {
                    let movePlayerRight = SKAction.move(to: gridPosition(blockSize: blockSize, row: curRow, col: curCol + 1), duration: 0.1)
                    Player.run(movePlayerRight)
                    curCol = curCol + 1
                }
                else {
                    movePlayerToStart()
                }
            }
        default:
            return
        }
    }
    
    func movePlayerToStart() {
        Player.position = gridPosition(blockSize: blockSize, row: numRows - 1, col: numCols/2)
        curRow = numRows - 1
        curCol = numCols / 2
        for i in travelledPath {
            if matrix.arr[i.row][i.col].pathIndex < maxIndex {
                matrix.arr[i.row][i.col].sprite.color = .white
            }
        }
    }
    
    func clearTravelledPath() {
        travelledPath.removeAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            startOfTouch = t.location(in: self)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            if inLevel == true {
                endOfTouch = t.location(in: self)
                let xDelta = endOfTouch.x - startOfTouch.x
                let yDelta = endOfTouch.y - startOfTouch.y
                var angle = atan2(yDelta, xDelta)
                if yDelta < 0 {
                    angle = angle + (2 * CGFloat.pi)
                }
                
                if angle >= (CGFloat.pi / 4) && angle < (3 * CGFloat.pi / 4) {
                    movePlayer("up")
                }
                else if angle >= (3 * CGFloat.pi / 4) && angle < (5 * CGFloat.pi / 4) {
                    movePlayer("left")
                }
                else if angle >= (5 * CGFloat.pi / 4) && angle < (7 * CGFloat.pi / 4) {
                    movePlayer("down")
                }
                else {
                    movePlayer("right")
                }
                
                if matrix.arr[curRow][curCol].pathIndex != 0 {
                    matrix.arr[curRow][curCol].sprite.color = .yellow
                    matrix.arr[curRow][curCol].sprite.colorBlendFactor = 1
                    if matrix.arr[curRow][curCol].pathIndex > maxIndex {
                        maxIndex = matrix.arr[curRow][curCol].pathIndex
                    }
                    travelledPath.insert(Index(hashValue: (curRow*curRow*curCol)%(numRows*numCols), row: curRow, col: curCol))
                }
            }
        }
    }
}
