//
//  DrawingObjectEntity.swift
//  
//
//  Created by Narumichi Kubo on 2023/11/04.
//

import Foundation

public protocol DrawingObjectProperty: Codable {
    var id: UUID { get set }
    var type: DrawingObjectType { get set }
    var state: DrawingObjectState { get set }
    var start: Coordinate { get set }
    var end: Coordinate { get set }
    var color: DrawingObjectColor { get }
}

/// ペン
public struct DrawingPencilObjectEntity: DrawingObjectProperty, Codable {
    public var id: UUID
    public var type: DrawingObjectType
    public var state: DrawingObjectState
    public var start: Coordinate
    public var end: Coordinate
    public var color: DrawingObjectColor

    public var points: [Coordinate]
    public var lineWidth: Double

    public init(id: UUID, type: DrawingObjectType, state: DrawingObjectState, start: Coordinate, end: Coordinate, color: DrawingObjectColor, points: [Coordinate], lineWidth: Double) {
        self.id = id
        self.type = type
        self.state = state
        self.start = start
        self.end = end
        self.color = color
        self.points = points
        self.lineWidth = lineWidth
    }
}

/// 矢印
public struct DrawingArrowObjectEntity: DrawingObjectProperty, Codable {
    public var id: UUID
    public var type: DrawingObjectType
    public var state: DrawingObjectState
    public var start: Coordinate
    public var end: Coordinate
    public var color: DrawingObjectColor
    public var lineWidth: Double
    
    public init(id: UUID, type: DrawingObjectType, state: DrawingObjectState, start: Coordinate, end: Coordinate, color: DrawingObjectColor, lineWidth: Double) {
        self.id = id
        self.type = type
        self.state = state
        self.start = start
        self.end = end
        self.color = color
        self.lineWidth = lineWidth
    }
}

/// 矩形
public struct DrawingRectangleObjectEntity: DrawingObjectProperty, Codable {
    public var id: UUID
    public var type: DrawingObjectType
    public var state: DrawingObjectState
    public var start: Coordinate
    public var end: Coordinate
    public var color: DrawingObjectColor
    public var lineWidth: Double

    public init(id: UUID, type: DrawingObjectType, state: DrawingObjectState, start: Coordinate, end: Coordinate, color: DrawingObjectColor, lineWidth: Double) {
        self.id = id
        self.type = type
        self.state = state
        self.start = start
        self.end = end
        self.color = color
        self.lineWidth = lineWidth
    }
}

/// 円
public struct DrawingCircleObjectEntity: DrawingObjectProperty, Codable {
    public var id: UUID
    public var type: DrawingObjectType
    public var state: DrawingObjectState
    public var start: Coordinate
    public var end: Coordinate
    public var color: DrawingObjectColor
    public var lineWidth: Double

    public init(id: UUID, type: DrawingObjectType, state: DrawingObjectState, start: Coordinate, end: Coordinate, color: DrawingObjectColor, lineWidth: Double) {
        self.id = id
        self.type = type
        self.state = state
        self.start = start
        self.end = end
        self.color = color
        self.lineWidth = lineWidth
    }
}
