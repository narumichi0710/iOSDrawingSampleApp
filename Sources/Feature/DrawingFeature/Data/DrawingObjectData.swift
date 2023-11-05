//
//  DrawingObjectData.swift
//
//
//  Created by Narumichi Kubo on 2023/11/04.
//

import SwiftUI
import Service
import Repository
import ViewExtension

public class DrawingObjectData: Equatable, ObservableObject {
    public var data: DrawingObjectProperty
    public var id: UUID { data.id }
    public var type: DrawingObjectType { data.type }
    public var state: DrawingObjectState { data.state }
    public var start: Coordinate { data.start }
    public var end: Coordinate { data.end }
    public var color: DrawingObjectColor { data.color }
    
    @Published private var modified: Date = .now

    public init(data: DrawingObjectProperty) {
        self.data = data
    }
    
    public func onStart(_ value: Coordinate) {
        data.start = value
        apply()
    }
    
    public func onEnd(_ value: Coordinate) {
        data.end = value
        apply()
    }
    
    public func apply() {
        modified = .now
    }
    
    public func updateState(_ value: DrawingObjectState) {
        data.state = value
    }

    public static func == (lhs: DrawingObjectData, rhs: DrawingObjectData) -> Bool {
        lhs.id == rhs.id
    }
}

/// ペン
public class DrawingPencilObjectData: DrawingObjectData {
    public var points: [Coordinate]
    public var lineWidth: Double

    public func onCreatePath(_ point: Coordinate) {
        points.append(point)
        apply()
    }

    public func onEndDrawing() {}

    public init(entity: DrawingPencilObjectEntity) {
        points = entity.points
        lineWidth = entity.lineWidth
        super.init(data: entity)
    }

    public static func create(
        _ setting: DrawingSettingData,
        _ coordinate: Coordinate
    ) -> DrawingPencilObjectData {
        .init(entity: .init(
            id: UUID(),
            type: .pencil,
            state: .created,
            start: coordinate,
            end: coordinate,
            color: setting.color,
            points: .init(),
            lineWidth: setting.lineWidth
        ))
    }
}

/// 矢印
public class DrawingArrowObjectData: DrawingObjectData {
    public var lineWidth: Double

    public init(entity: DrawingArrowObjectEntity) {
        lineWidth = entity.lineWidth
        super.init(data: entity)
    }
    
    public static func create(
        _ setting: DrawingSettingData,
        _ coordinate: Coordinate
    ) -> DrawingArrowObjectData {
        .init(entity: .init(
            id: UUID(),
            type: .arrowLine,
            state: .created,
            start: coordinate,
            end: coordinate,
            color: setting.color,
            lineWidth: setting.lineWidth
        ))
    }
}

/// 矩形
public class DrawingRectangleObjectData: DrawingObjectData {
    public var lineWidth: Double

    public init(entity: DrawingRectangleObjectEntity) {
        lineWidth = entity.lineWidth
        super.init(data: entity)
    }
    
    public static func create(
        _ setting: DrawingSettingData,
        _ coordinate: Coordinate
    ) -> DrawingRectangleObjectData {
        .init(entity: .init(
            id: UUID(),
            type: .arrowLine,
            state: .created,
            start: coordinate,
            end: coordinate,
            color: setting.color,
            lineWidth: setting.lineWidth
        ))
    }
}

/// 円
public class DrawingCircleObjectData: DrawingObjectData {
    public var lineWidth: Double

    public init(entity: DrawingCircleObjectEntity) {
        lineWidth = entity.lineWidth
        super.init(data: entity)
    }
    
    public static func create(
        _ setting: DrawingSettingData,
        _ coordinate: Coordinate
    ) -> DrawingCircleObjectData {
        .init(entity: .init(
            id: UUID(),
            type: .arrowLine,
            state: .created,
            start: coordinate,
            end: coordinate,
            color: setting.color,
            lineWidth: setting.lineWidth
        ))
    }
}

public extension DrawingObjectData {
    func asPencil() -> DrawingPencilObjectData? {
        self as? DrawingPencilObjectData
    }
    func asArrow() -> DrawingArrowObjectData? {
        self as? DrawingArrowObjectData
    }
    func asRectangle() -> DrawingRectangleObjectData? {
        self as? DrawingRectangleObjectData
    }
    func asCircle() -> DrawingCircleObjectData? {
        self as? DrawingCircleObjectData
    }
}

public extension DrawingObjectColor {
    var toUIColor: Color { .init(hex: rawValue) }
}
