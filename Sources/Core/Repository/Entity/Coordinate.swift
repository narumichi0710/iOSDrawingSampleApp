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
    public var info: Info?
    
    public struct Info: Codable {
        public var interval: Double?
        public var text: String?
        
        public init(interval: Double? = nil, text: String? = nil) {
            self.interval = interval
            self.text = text
        }
    }

    public var cgPoint: CGPoint {
        CGPoint(x: x, y: y)
    }

    public init(
        x: Double = .zero,
        y: Double = .zero,
        info: Info? = nil
    ) {
        self.x = x
        self.y = y
        self.info = info
    }
}
