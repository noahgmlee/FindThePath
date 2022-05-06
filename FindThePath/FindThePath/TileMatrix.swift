//
//  TileMatrix.swift
//  FindThePath
//
//  Created by Noah Lee on 2021-01-07.
//  Copyright © 2021 NoahAle. All rights reserved.
//

import SpriteKit

struct Index : Hashable{
    var hashValue: Int
    
    static func ==(lhs: Index, rhs: Index) -> Bool {
        return (lhs.row == rhs.row) && (lhs.col == rhs.col)
    }
    
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
    var pathLen:Int!
    
    convenience init(rows: Int, cols: Int){
        self.init()
        self.numRows = rows
        self.numCols = cols
        self.arr = [[Tile]](repeating: [Tile](repeating: Tile(isPath: false, pathIndex: 0, sprite: SKSpriteNode.init()), count: numCols), count: numRows)
    }
    
    func createPath() {
        var curRow = numRows - 2
        var curCol = numCols / 2
        var curPathIndex = 1
        for i in 0..<(numCols) {
            arr[0][i].isPath = true
            arr[numRows - 1][i].isPath = true
        }
        
        arr[curRow][curCol].isPath = true
        arr[curRow][curCol].pathIndex = curPathIndex
        
        while curRow > 1 {
            let dir = Int(arc4random_uniform(3)) //0 = left, 1 = up, 2 = right
            if dir == 0 {
                if curCol > 0 {
                    if !arr[curRow][curCol - 1].isPath && !arr[curRow + 1][curCol - 1].isPath {
                        curCol -= 1
                        curPathIndex += 1
                    }
                }
            }
            if dir == 1 {
                if curRow > 0 {
                    if !arr[curRow - 1][curCol].isPath {
                        curRow -= 1
                        curPathIndex += 1
                    }
                }
            }
            if dir == 2 {
                if curCol < numCols - 1 {
                    if !arr[curRow][curCol + 1].isPath && !arr[curRow + 1][curCol + 1].isPath {
                        curCol += 1
                        curPathIndex += 1
                    }
                }
            }
            arr![curRow][curCol].isPath = true
            arr![curRow][curCol].pathIndex = curPathIndex
        }
        pathLen = curPathIndex
        for (count, row) in arr.enumerated(){
            for val in row {
                print(val.isPath, terminator:"")
                print(val.pathIndex, terminator: " ")
            }
            print("\n")
        }
    }
}
