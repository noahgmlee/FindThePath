//
//  GameScene.swift
//  FindThePath
//
//  Created by Noah Lee on 2021-01-06.
//  Copyright © 2021 NoahAle. All rights reserved.
//

import SpriteKit
import GameplayKit

let screenSize = UIScreen.main.bounds

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
    
    var blockWidth:CGFloat!
    var blockHeight:CGFloat!
    /*var gameArea:CGRect
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func didMove(to view: SKView) {
        
        //blockSize = screenSize.height/CGFloat(numCols) //this will be deleted when we have set sized sprites
        //blockSize = gameArea.width/CGFloat(numCols)
        blockWidth = self.size.width/CGFloat(numCols)
        blockHeight = self.size.height/CGFloat(numRows)
        Player = SKSpriteNode(imageNamed: "Player")
        Player.setScale(blockWidth/64.0 * 0.75)
        Player.position = gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: numRows - 1, col: numCols/2)
        Player.zPosition = 3.0
        self.addChild(Player)
        curRow = numRows - 1
        curCol = numCols / 2
        
        startNewLevel()
    }
    
    func drawGrid(_ numRows:Int, _ numCols:Int) {
        
        //blockSize = screenSize.height/CGFloat(numCols)
        //blockSize = gameArea.width/CGFloat(numCols)
        blockWidth = self.size.width/CGFloat(numCols)
        blockHeight = self.size.height/CGFloat(numRows)
        matrix = TileMatrix(rows: numRows, cols: numCols)
        for row in 0..<numRows {
            if row == 0 || row == numRows - 1 {
                for col in 0..<numCols {
                    let platform = SKSpriteNode(imageNamed: "WoodPlatform")
                    platform.setScale(blockWidth/64.0)
                    platform.position = gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row:row, col:col)
                    platform.zPosition = 2.0
                    self.addChild(platform)
                    matrix.arr[row][col].sprite = platform
                }
            }
            else {
                for col in 0..<numCols {
                    let tile = SKSpriteNode(imageNamed: "Tile")
                    tile.setScale(blockWidth/64.0 * 0.9)
                    tile.position = gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: row, col: col)
                    tile.zPosition = 2.0
                    self.addChild(tile)
                    matrix.arr[row][col].sprite = tile
                }
            }
        }
        matrix.createPath()
        
    }
    
    func deleteGrid() {
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
        if level % 2 == 0 {
            numRows += 2
            numCols += 2
        }
        drawGrid(numRows, numCols)
        Player.setScale(blockWidth/64.0 * 0.75)
        Player.position = gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: numRows - 1, col: numCols/2)
        curRow = numRows - 1
        curCol = numCols / 2
        inLevel = true
    }
    
    func endLevel() {
        inLevel = false
        deleteGrid()
        clearTravelledPath()
        startNewLevel()
    }
    
    func endLevelPlayerAnimation() {
        let movePlayerUp = SKAction.move(to: gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: curRow - 1, col: curCol), duration: 0.1)
        curRow = curRow - 1
        let movePlayerOutOfScene = SKAction.move(by: CGVector(dx: 0, dy: blockHeight), duration: 0.5)
        var movesFromMidCol = numCols / 2 - curCol
        if movesFromMidCol != 0 {
            var movePlayerTowardsMidCol:SKAction!
            if movesFromMidCol > 0 {
                movePlayerTowardsMidCol = SKAction.move(by: CGVector(dx: blockWidth, dy: 0), duration: 0.1)
            }
            else if movesFromMidCol < 0 {
                movesFromMidCol *= -1
                movePlayerTowardsMidCol = SKAction.move(by: CGVector(dx: -blockWidth, dy: 0), duration: 0.1)
            }
            let movePlayerToMidCol = SKAction.repeat(movePlayerTowardsMidCol, count: movesFromMidCol)
            let endSequence = SKAction.sequence([movePlayerUp, SKAction.wait(forDuration: 1), movePlayerToMidCol, SKAction.wait(forDuration: 1), movePlayerOutOfScene, SKAction.run(movePlayerToStart), SKAction.run(endLevel)])
            Player.run(endSequence)
        }
        else {
            let endSequence = SKAction.sequence([movePlayerUp, SKAction.wait(forDuration: 1), movePlayerOutOfScene, /*SKAction.run(movePlayerToStart),*/ SKAction.run(endLevel)])
            Player.run(endSequence)
        }
    }
    
    func gridPosition(blockWidth:CGFloat, blockHeight:CGFloat, row:Int, col:Int) -> CGPoint {
        let xoffset = blockWidth / 2.0 + 0.5
        let yoffset = blockHeight / 2.0 + 0.5
        let x = CGFloat(col) * blockWidth - (blockWidth * CGFloat(numCols)) / 2.0 + xoffset
        let y = CGFloat(numRows - row - 1) * blockHeight - (blockHeight * CGFloat(numRows)) / 2.0 + yoffset
        return CGPoint(x:x, y:y)
    }
    
    func movePlayer(_ dir:String) {
        switch dir {
        case "up":
            if curRow > 0 {
                if matrix.arr[curRow - 1][curCol].isPath == true {
                    let movePlayerUp = SKAction.move(to: gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: curRow - 1, col: curCol), duration: 0.1)
                    if curRow - 1 == 0 {
                        endLevelPlayerAnimation()
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
                    let movePlayerLeft = SKAction.move(to: gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: curRow, col: curCol - 1), duration: 0.1)
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
                    let movePlayerDown = SKAction.move(to: gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: curRow + 1, col: curCol), duration: 0.1)
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
                    let movePlayerRight = SKAction.move(to: gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: curRow, col: curCol + 1), duration: 0.1)
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
        //Player.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.run({self.Player.position = self.gridPosition(blockSize: self.blockSize, row: self.numRows - 1, col: self.numCols/2)}), SKAction.fadeIn(withDuration: 0.5)]))
        Player.position = gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: numRows - 1, col: numCols/2)
        curRow = numRows - 1
        curCol = numCols / 2
        for i in travelledPath {
            if matrix.arr[i.row][i.col].pathIndex < maxIndex {
                let changeToWhite = SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.5)
                matrix.arr[i.row][i.col].sprite.run(changeToWhite)
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
