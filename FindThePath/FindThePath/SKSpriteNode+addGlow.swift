//
//  SKSpriteNode+addGlow.swift
//  FindThePath
//
//  Created by Alessandro Menchetti on 2021-01-20.
//  Copyright © 2021 NoahAle. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {

    func addGlow(radius: Float = 100) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])
    }
}
