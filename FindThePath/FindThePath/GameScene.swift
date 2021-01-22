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
var aspectRatio:String!
var level = 0

class GameScene: SKScene {
    
    var numRows = 6
    var numCols = 3
    
    var inLevel = false
    var gameOver = false
    var timeRemaining = 15
    
    var curRow:Int!
    var curCol:Int!
    var maxIndex = 0
    var matrix:TileMatrix!
    var travelledPath = Set<Index>()
    
    var Player:SKSpriteNode!
    var frogTextures:[SKTexture] = []
    var frogJumpAnimation:SKAction!
    var slowFrogJumpAnimation:SKAction!
    var levelLabel = SKLabelNode(fontNamed: "theboldfont")
    var timerLabel = SKLabelNode(fontNamed: "theboldfont")
    let fadeIn = SKAction.fadeIn(withDuration: 1)
    let fadeOut = SKAction.fadeOut(withDuration: 1)
    
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
        //blockWidth = self.size.width/CGFloat(numCols)
        //blockHeight = self.size.height/CGFloat(numRows)
        
        //print(screenSize.width)
        //print(screenSize.height)
        
        for i in 1...7 {
            frogTextures.append(SKTexture(imageNamed: "frog\(i)"))
        }
        frogJumpAnimation = SKAction.animate(with: frogTextures, timePerFrame: 0.2/7, resize: false, restore: true)
        slowFrogJumpAnimation = SKAction.animate(with: frogTextures, timePerFrame: 0.5/7, resize: false, restore: true)
        
        Player = SKSpriteNode(imageNamed: "frog1")
        //Player.setScale(blockWidth/64.0 * 0.75)
        //Player.position = gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: numRows - 1, col: numCols/2)
        Player.zPosition = 3.0
        self.addChild(Player)
        
        levelLabel.fontSize = screenSize.width * 0.05
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        if aspectRatio == "19.5by9" {
            levelLabel.position = CGPoint(x: -self.size.width/2 * 0.86, y: self.size.height/2 * 0.93)
        }
        else {
            levelLabel.position = CGPoint(x: -self.size.width/2 * 0.95, y: self.size.height/2 * 0.925)
        }
        levelLabel.zPosition = 100
        levelLabel.color = .white
        self.addChild(levelLabel)
        
        timerLabel.text = "\(timeRemaining)"
        timerLabel.fontSize = screenSize.width * 0.07
        timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        if aspectRatio == "19.5by9" {
            timerLabel.position = CGPoint(x: self.size.width/2 * 0.81, y: self.size.height/2 * 0.925)
        }
        else {
            timerLabel.position = CGPoint(x: self.size.width/2 * 0.95, y: self.size.height/2 * 0.9)
        }
        timerLabel.zPosition = 100
        timerLabel.color = .white
        self.addChild(timerLabel)
        
        //timeRemaining = 10
        curRow = numRows - 1
        curCol = numCols / 2
        
        startNewLevel()
        drawBackground()
    }
    
    func drawBackground() {
        let size = CGFloat(280.0)
        let bgCols = Int(self.size.width/size) + 1
        let bgRows = Int(self.size.height/size) + 1
        
        print(bgCols)
        for row in 0..<bgRows {
            for col in 0..<bgCols {
                let bgTile = SKSpriteNode(imageNamed: "bg_tile")
                bgTile.setScale(1)
                bgTile.position = bgGridPosition(blockSize: size, bgRows: bgRows, bgCols: bgCols, row: row, col: col)
                bgTile.zPosition = 1.0
                self.addChild(bgTile)
            }
        }
        /*print(self.size.height)
        print(screenSize.height)
        print(bgRows)*/
    }
    
    func drawGrid(_ numRows:Int, _ numCols:Int) {
        
        //blockSize = screenSize.height/CGFloat(numCols)
        //blockSize = gameArea.width/CGFloat(numCols)
        blockWidth = self.size.width/CGFloat(numCols)
        blockHeight = self.size.height/CGFloat(numRows)
        
        /*if aspectRatio == "16by9" {
            blockWidth = (self.size.height * (9 / 16)) / CGFloat(numCols)
        }
        else if aspectRatio == "19.5by9" {
            blockWidth = (self.size.height * (9 / 19.5)) / CGFloat(numCols)
        }
        else {
            blockWidth = (self.size.height * (3 / 4)) / CGFloat(numCols)
        }*/
        
        matrix = TileMatrix(rows: numRows, cols: numCols)
        for row in 0..<numRows {
            if row == 0 || row == numRows - 1 {
                for col in 0..<numCols {
                    let grass = SKSpriteNode(imageNamed: "grass")
                    //platform.setScale(blockWidth/64.0)
                    //platform.setScale(blockWidth < blockHeight ? (blockWidth/64.0) : (blockHeight/64.0))
                    grass.xScale = blockWidth/2048.0
                    grass.yScale = blockHeight/1536.0
                    grass.position = gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row:row, col:col)
                    grass.zPosition = 2.0
                    self.addChild(grass)
                    matrix.arr[row][col].sprite = grass
                }
            }
            else {
                for col in 0..<numCols {
                    let angle = Int(arc4random_uniform(UInt32(360)))
                    let lilypad = SKSpriteNode(imageNamed: "lilypad_green")
                    //tile.setScale(blockHeight/224.0 * 0.9)
                    lilypad.zRotation = CGFloat(angle) * CGFloat.pi / 180
                    lilypad.setScale(blockWidth < blockHeight ? (blockWidth/228.0 * 0.9) : (blockHeight/224.0 * 0.9))
                    lilypad.position = gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: row, col: col)
                    lilypad.zPosition = 2.0
                    self.addChild(lilypad)
                    matrix.arr[row][col].sprite = lilypad
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
        if aspectRatio == "19.5by9" {
            levelLabel.text = "Lvl: \(level)"
        }
        else {
            levelLabel.text = "Level: \(level)"
        }
        if level > 1 {
            timeRemaining += 30
            timerLabel.text = "\(timeRemaining)"
        }
        print("Level: \(level)")
        if level % 2 == 0 {
            numRows += 2
            numCols += 2
        }
        drawGrid(numRows, numCols)
        //Player.setScale(blockWidth/64.0 * 0.75)
        Player.setScale(blockWidth/232.0 * 0.7)
        let movePlayerUp = SKAction.move(to: gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: numRows - 1, col: numCols/2), duration: 0.75)
        let movePlayerAnimation = SKAction.group([slowFrogJumpAnimation, movePlayerUp])
        
        Player.position = gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: numRows, col: numCols/2)
        Player.run(movePlayerAnimation)
        //Player.run(frogTextureAnimation)
        curRow = numRows - 1
        curCol = numCols / 2
        maxIndex = 0
        startTimer()
        inLevel = true
    }
    
    func endLevel() {
        inLevel = false
        deleteGrid()
        clearTravelledPath()
        if gameOver == false {
            startNewLevel()
        }
        else {
            let sceneToMoveTo = GameOverScene(fileNamed: "GameOverScene")
            sceneToMoveTo!.scaleMode = self.scaleMode
            sceneToMoveTo!.size = self.size
            let fadeTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo!, transition: fadeTransition)
        }
    }
    
    func startTimer() {
        let updateTimerAction = SKAction.run(updateTimer)
        let wait1sec = SKAction.wait(forDuration: 1)
        let timerSequence = SKAction.sequence([wait1sec, updateTimerAction])
        let repeatTimerSequence = SKAction.repeatForever(timerSequence)
        run(repeatTimerSequence, withKey: "timer")
        
    }
    
    func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            timerLabel.text = "\(timeRemaining)"
            if timeRemaining > 10 && timeRemaining <= 30 && timerLabel.color != .yellow {
                timerLabel.color = .yellow
                timerLabel.colorBlendFactor = 1
            }
            else if timeRemaining <= 10 {
                if timerLabel.color != .red {
                    timerLabel.color = .red
                    timerLabel.colorBlendFactor = 1
                }
                let scaleUp = SKAction.scale(to: 1.3, duration: 0.2)
                let scaleDown = SKAction.scale(to: 1, duration: 0.2)
                let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
                timerLabel.run(scaleSequence)
            }
        }
        else {
            gameOver = true
            endLevel()
        }
    }
    
    func failAnimation() {
        let shrink = SKAction.scale(to: 0, duration: 0.5)
        let rotate = SKAction.rotate(byAngle: 360 * CGFloat.pi / 180, duration: 0.5)
        let fallAnimation = SKAction.group([shrink, rotate])
        Player.run(fallAnimation)
        matrix.arr[curRow][curCol].sprite.run(fallAnimation)
    }
    
    func endLevelPlayerAnimation() {
        let movePlayerUp = SKAction.move(to: gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: curRow - 1, col: curCol), duration: 0.2)
        let movePlayerAnimation = SKAction.group([frogJumpAnimation, movePlayerUp])
        curRow = curRow - 1
        let movePlayerOutOfScene = SKAction.move(by: CGVector(dx: 0, dy: blockHeight), duration: 0.5)
        let movePlayerOutOfSceneAnimation = SKAction.group([frogJumpAnimation, movePlayerOutOfScene])
        /*var movesFromMidCol = numCols / 2 - curCol
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
            let endSequence = SKAction.sequence([movePlayerUp, SKAction.wait(forDuration: 1), movePlayerOutOfScene, SKAction.run(endLevel)])
            Player.run(endSequence)
        }*/
        let endSequence = SKAction.sequence([movePlayerAnimation, SKAction.wait(forDuration: 1), movePlayerOutOfSceneAnimation, SKAction.run(fadeScreen), SKAction.wait(forDuration: 1), SKAction.run(endLevel)])
        Player.run(endSequence)
    }
    
    func fadeScreen() {
        let fadeSequence = SKAction.sequence([fadeOut, fadeIn])
        self.run(fadeSequence)
    }
    
    func gridPosition(blockWidth:CGFloat, blockHeight:CGFloat, row:Int, col:Int) -> CGPoint {
        let xoffset = blockWidth / 2.0 + 0.5
        let yoffset = blockHeight / 2.0 + 0.5
        let x = CGFloat(col) * blockWidth - (blockWidth * CGFloat(numCols)) / 2.0 + xoffset
        let y = CGFloat(numRows - row - 1) * blockHeight - (blockHeight * CGFloat(numRows)) / 2.0 + yoffset
        return CGPoint(x:x, y:y)
    }
    
    func bgGridPosition(blockSize:CGFloat, bgRows:Int, bgCols:Int, row:Int, col:Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        let x = CGFloat(col) * blockSize - (blockSize * CGFloat(bgCols)) / 2.0 + offset
        let y = CGFloat(bgRows - row - 1) * blockSize - (blockSize * CGFloat(bgRows)) / 2.0 + offset
        return CGPoint(x:x, y:y)
    }
    
    func movePlayer(_ dir:String) {
        var movePlayerAnimation:SKAction!
        var rotatePlayer:SKAction!
        switch dir {
        case "up":
            if curRow > 0 { //stop player from moving out of grid
                let movePlayerUp = SKAction.move(to: gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: curRow - 1, col: curCol), duration: 0.2)
                movePlayerAnimation = SKAction.group([frogJumpAnimation, movePlayerUp])
                rotatePlayer = SKAction.rotate(toAngle: CGFloat(0) * CGFloat.pi / 180, duration: 0.1)
                if matrix.arr[curRow - 1][curCol].isPath == true { //if move is valid
                    if curRow - 1 == 0 { //if player made it to end
                        removeAction(forKey: "timer")
                        endLevelPlayerAnimation()
                    }
                    else { //if it is just a regular move
                        if Player.zRotation == 0 {
                            Player.run(SKAction.sequence([movePlayerAnimation, SKAction.run(updateTravelledPath)]))
                        }
                        else {
                            Player.run(SKAction.sequence([rotatePlayer, movePlayerAnimation, SKAction.run(updateTravelledPath)]))
                        }
                        curRow = curRow - 1
                    }
                }
                else { //if move is not valid
                    curRow = curRow - 1
                    if Player.zRotation == 0 {
                        Player.run(SKAction.sequence([movePlayerAnimation, SKAction.run(failAnimation), SKAction.wait(forDuration: 0.5), SKAction.run(movePlayerToStart)]))
                    }
                    else {
                        Player.run(SKAction.sequence([rotatePlayer, movePlayerAnimation, SKAction.run(failAnimation), SKAction.wait(forDuration: 0.5), SKAction.run(movePlayerToStart)]))
                    }
                    //movePlayerToStart()
                }
            }
        case "left":
            if curCol > 0 { //stop player from moving out of grid
                let movePlayerLeft = SKAction.move(to: gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: curRow, col: curCol - 1), duration: 0.2)
                movePlayerAnimation = SKAction.group([frogJumpAnimation, movePlayerLeft])
                rotatePlayer = SKAction.rotate(toAngle: CGFloat(90) * CGFloat.pi / 180, duration: 0.1)
                if matrix.arr[curRow][curCol - 1].isPath == true { //if move is valid
                    
                    if Player.zRotation == 90 {
                        Player.run(SKAction.sequence([movePlayerAnimation, SKAction.run(updateTravelledPath)]))
                    }
                    else {
                        Player.run(SKAction.sequence([rotatePlayer, movePlayerAnimation, SKAction.run(updateTravelledPath)]))
                    }
                    curCol = curCol - 1
                }
                else { //if move is not valid
                    curCol = curCol - 1
                    if Player.zRotation == 90 {
                        Player.run(SKAction.sequence([movePlayerAnimation, SKAction.run(failAnimation), SKAction.wait(forDuration: 0.5), SKAction.run(movePlayerToStart)]))
                    }
                    else {
                        Player.run(SKAction.sequence([rotatePlayer, movePlayerAnimation, SKAction.run(failAnimation), SKAction.wait(forDuration: 0.5), SKAction.run(movePlayerToStart)]))
                    }
                    //movePlayerToStart()
                }
            }
        case "down":
            if curRow < numRows - 1 { //stop player from moving out of grid
                let movePlayerDown = SKAction.move(to: gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: curRow + 1, col: curCol), duration: 0.2)
                movePlayerAnimation = SKAction.group([frogJumpAnimation, movePlayerDown])
                rotatePlayer = SKAction.rotate(toAngle: CGFloat(180) * CGFloat.pi / 180, duration: 0.1)
                if matrix.arr[curRow + 1][curCol].isPath == true { //if move is valid
                    
                    if Player.zRotation == 180 {
                        Player.run(SKAction.sequence([movePlayerAnimation, SKAction.run(updateTravelledPath)]))
                    }
                    else {
                        Player.run(SKAction.sequence([rotatePlayer, movePlayerAnimation, SKAction.run(updateTravelledPath)]))
                    }
                    curRow = curRow + 1
                }
                else { //if move is not valid
                    curRow = curRow + 1
                    if Player.zRotation == 180 {
                        Player.run(SKAction.sequence([movePlayerAnimation, SKAction.run(failAnimation), SKAction.wait(forDuration: 0.5), SKAction.run(movePlayerToStart)]))
                    }
                    else {
                        Player.run(SKAction.sequence([rotatePlayer, movePlayerAnimation, SKAction.run(failAnimation), SKAction.wait(forDuration: 0.5), SKAction.run(movePlayerToStart)]))
                    }
                    //movePlayerToStart()
                }
            }
        case "right":
            if curCol < numCols - 1 { //stop player from moving out of grid
                let movePlayerRight = SKAction.move(to: gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: curRow, col: curCol + 1), duration: 0.2)
                movePlayerAnimation = SKAction.group([frogJumpAnimation, movePlayerRight])
                rotatePlayer = SKAction.rotate(toAngle: CGFloat(270) * CGFloat.pi / 180, duration: 0.1)
                if matrix.arr[curRow][curCol + 1].isPath == true { //if move is valid
                    
                    if Player.zRotation == 270 {
                        Player.run(SKAction.sequence([movePlayerAnimation, SKAction.run(updateTravelledPath)]))
                    }
                    else {
                        Player.run(SKAction.sequence([rotatePlayer, movePlayerAnimation, SKAction.run(updateTravelledPath)]))
                    }
                    curCol = curCol + 1
                }
                else { //if move is not valid
                    curCol = curCol + 1
                    if Player.zRotation == 270 {
                        Player.run(SKAction.sequence([movePlayerAnimation, SKAction.run(failAnimation), SKAction.wait(forDuration: 0.5), SKAction.run(movePlayerToStart)]))
                    }
                    else {
                        Player.run(SKAction.sequence([rotatePlayer, movePlayerAnimation, SKAction.run(failAnimation), SKAction.wait(forDuration: 0.5), SKAction.run(movePlayerToStart)]))
                    }
                    //movePlayerToStart()
                }
            }
        default:
            return
        }
    }
    
    func movePlayerToStart() {
        //Player.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.run({self.Player.position = self.gridPosition(blockSize: self.blockSize, row: self.numRows - 1, col: self.numCols/2)}), SKAction.fadeIn(withDuration: 0.5)]))
        let movePlayerUp = SKAction.move(to: gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: numRows - 1, col: numCols/2), duration: 0.75)
        let movePlayerAnimation = SKAction.group([slowFrogJumpAnimation, movePlayerUp])
        
        Player.position = gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: numRows, col: numCols/2)
        matrix.arr[curRow][curCol].sprite.run(SKAction.scale(to: (blockWidth < blockHeight ? (blockWidth/228.0 * 0.9) : (blockHeight/224.0 * 0.9)), duration: 0.5))
        //Player.zRotation = 0
        Player.run(SKAction.rotate(toAngle: CGFloat(0) * CGFloat.pi / 180, duration: 0.1))
        Player.run(SKAction.scale(to: blockWidth/232.0 * 0.7, duration: 0.5))
        Player.run(movePlayerAnimation)
        //Player.position = gridPosition(blockWidth: blockWidth, blockHeight: blockHeight, row: numRows - 1, col: numCols/2)
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
    
    func updateTravelledPath() {
        if matrix.arr[curRow][curCol].pathIndex != 0 {
            matrix.arr[curRow][curCol].sprite.color = .red
            matrix.arr[curRow][curCol].sprite.colorBlendFactor = 0.5
            //matrix.arr[curRow][curCol].sprite.addGlow()
            if matrix.arr[curRow][curCol].pathIndex > maxIndex {
                maxIndex = matrix.arr[curRow][curCol].pathIndex
            }
            travelledPath.insert(Index(hashValue: (curRow*curRow*curCol)%(numRows*numCols), row: curRow, col: curCol))
        }
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
            }
        }
    }
}
