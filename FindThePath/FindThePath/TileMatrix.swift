//
//  TileMatrix.swift
//  FindThePath
//
//  Created by Noah Lee on 2021-01-07.
//  Copyright © 2021 NoahAle. All rights reserved.
//

import SpriteKit

struct Index : Hashable{
    var row:Int!
    var col:Int!
}
struct Tile {
    var isPath = false
    var pathIndex = 0
    var sprite:SKSpriteNode!
}

class TileMatrix{
    
    var numRows:Int!
    var numCols:Int!
    var arr:[[Tile]]!
    
    convenience init(rows: Int, cols: Int){
        self.init()
        self.numRows = rows
        self.numCols = cols
        self.arr = [[Tile]](repeating: [Tile](repeating: Tile(isPath: false, pathIndex: 0, sprite: SKSpriteNode.init()), count: numCols), count: numRows)
    }
    
    func createPath() {
        let startIndex = Int(arc4random_uniform(UInt32(numCols)))
        var curRow = numRows - 2
        var curColumn = startIndex
        var curPathIndex = 1
        for i in 0..<(numCols) {
            arr[0][i].isPath = true
            arr[numRows - 1][i].isPath = true
        }
        
        arr[curRow][startIndex].isPath = true
        arr[curRow][startIndex].pathIndex = curPathIndex
        
        while curRow > 1 {
            let dir = Int(arc4random_uniform(3)) //0 = left, 1 = up, 2 = right
            if dir == 0 {
                if curColumn > 0 {
                    if !arr[curRow][curColumn - 1].isPath {
                        curColumn -= 1
                        curPathIndex += 1
                    }
                }
            }
            if dir == 1 {
                if curRow > 0 {
                    if !arr[curRow - 1][curColumn].isPath {
                        curRow -= 1
                        curPathIndex += 1
                    }
                }
            }
            if dir == 2 {
                if curColumn < numCols - 1 {
                    if !arr[curRow][curColumn + 1].isPath {
                        curColumn += 1
                        curPathIndex += 1
                    }
                }
            }
            arr![curRow][curColumn].isPath = true
            arr![curRow][curColumn].pathIndex = curPathIndex
        }
        for (count, row) in arr.enumerated(){
            for val in row {
                print(val.isPath, terminator:"")
                print(val.pathIndex, terminator: " ")
            }
            print("\n")
        }
    }
}
