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
    var trajectory: [Coordinate] { get set }
}

/// ペン
public struct DrawingPencilObjectEntity: DrawingObjectProperty, Codable {
    public var id: UUID
    public var type: DrawingObjectType
    public var state: DrawingObjectState
    public var start: Coordinate
    public var end: Coordinate
    public var color: DrawingObjectColor
    public var lineWidth: Double
    public var trajectory: [Coordinate]

    public init(id: UUID, type: DrawingObjectType, state: DrawingObjectState, start: Coordinate, end: Coordinate, color: DrawingObjectColor, lineWidth: Double, trajectory: [Coordinate]) {
        self.id = id
        self.type = type
        self.state = state
        self.start = start
        self.end = end
        self.color = color
        self.lineWidth = lineWidth
        self.trajectory = trajectory
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
    public var trajectory: [Coordinate]
    
    public init(id: UUID, type: DrawingObjectType, state: DrawingObjectState, start: Coordinate, end: Coordinate, color: DrawingObjectColor, lineWidth: Double, trajectory: [Coordinate]) {
        self.id = id
        self.type = type
        self.state = state
        self.start = start
        self.end = end
        self.color = color
        self.lineWidth = lineWidth
        self.trajectory = trajectory
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
    public var trajectory: [Coordinate]
    
    public init(id: UUID, type: DrawingObjectType, state: DrawingObjectState, start: Coordinate, end: Coordinate, color: DrawingObjectColor, lineWidth: Double, trajectory: [Coordinate]) {
        self.id = id
        self.type = type
        self.state = state
        self.start = start
        self.end = end
        self.color = color
        self.lineWidth = lineWidth
        self.trajectory = trajectory
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
    public var trajectory: [Coordinate]
    
    public init(id: UUID, type: DrawingObjectType, state: DrawingObjectState, start: Coordinate, end: Coordinate, color: DrawingObjectColor, lineWidth: Double, trajectory: [Coordinate]) {
        self.id = id
        self.type = type
        self.state = state
        self.start = start
        self.end = end
        self.color = color
        self.lineWidth = lineWidth
        self.trajectory = trajectory
    }
}

/// 楕円
public struct DrawingOvalObjectEntity: DrawingObjectProperty, Codable {
    public var id: UUID
    public var type: DrawingObjectType
    public var state: DrawingObjectState
    public var start: Coordinate
    public var end: Coordinate
    public var color: DrawingObjectColor
    public var lineWidth: Double
    public var trajectory: [Coordinate]
    
    public init(id: UUID, type: DrawingObjectType, state: DrawingObjectState, start: Coordinate, end: Coordinate, color: DrawingObjectColor, lineWidth: Double, trajectory: [Coordinate]) {
        self.id = id
        self.type = type
        self.state = state
        self.start = start
        self.end = end
        self.color = color
        self.lineWidth = lineWidth
        self.trajectory = trajectory
    }
}

/// テキスト
public struct DrawingTextObjectEntity: DrawingObjectProperty, Codable {
    public var id: UUID
    public var type: DrawingObjectType
    public var state: DrawingObjectState
    public var start: Coordinate
    public var end: Coordinate
    public var color: DrawingObjectColor
    public var backgroundColor: DrawingObjectColor
    public var text: String
    public var trajectory: [Coordinate]

    public init(id: UUID, type: DrawingObjectType, state: DrawingObjectState, start: Coordinate, end: Coordinate, color: DrawingObjectColor, backgroundColor: DrawingObjectColor, text: String, trajectory: [Coordinate]) {
        self.id = id
        self.type = type
        self.state = state
        self.start = start
        self.end = end
        self.color = color
        self.backgroundColor = backgroundColor
        self.text = text
        self.trajectory = trajectory
    }
}
