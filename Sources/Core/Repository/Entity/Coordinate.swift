//
//  Coordinate.swift
//
//
//  Created by Narumichi Kubo on 2023/11/04.
//

import Foundation

public struct Coordinate: Codable {
    public var x: Double
    public var y: Double
    public var createdAt: Double

    public var cgPoint: CGPoint {
        CGPoint(x: x, y: y)
    }

    public init(
        x: Double = .zero,
        y: Double = .zero,
        createdAt: Double = Date().timeIntervalSince1970
    ) {
        self.x = x
        self.y = y
        self.createdAt = createdAt
    }
}
