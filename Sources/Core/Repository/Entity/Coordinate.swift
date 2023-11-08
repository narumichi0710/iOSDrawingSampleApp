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
    public var interval: Double

    public var cgPoint: CGPoint {
        CGPoint(x: x, y: y)
    }

    public init(
        x: Double = .zero,
        y: Double = .zero,
        interval: Double = .zero
    ) {
        self.x = x
        self.y = y
        self.interval = interval
    }
}
