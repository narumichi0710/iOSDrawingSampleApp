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
    var color: String { get }
}

/// ペン
public struct DrawingPencilObjectEntity: DrawingObjectProperty, Codable {
    public var id: UUID
    public var type: DrawingObjectType
    public var state: DrawingObjectState
    public var start: Coordinate
    public var end: Coordinate
    public var color: String

    public var points: [Coordinate]
    public var lineWidth: Double

    public init(id: UUID, type: DrawingObjectType, state: DrawingObjectState, start: Coordinate, end: Coordinate, color: String, points: [Coordinate], lineWidth: Double) {
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
