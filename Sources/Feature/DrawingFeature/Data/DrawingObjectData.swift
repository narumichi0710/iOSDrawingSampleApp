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
    public var trajectory: [Coordinate] { data.trajectory }

    @Published private var modified: Date = .now

    public init(data: DrawingObjectProperty) {
        self.data = data
    }
    
    public func onStart(_ value: Coordinate) {
        data.start = value
        apply()
    }
    
    public func onAddRrajectory(_ coordinate: Coordinate) {
        data.trajectory.append(coordinate)
        apply()
    }
    
    public func onUpdate(_ start: Coordinate, _ end: Coordinate) {
        data.start = start
        data.end = end
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
    public var lineWidth: Double

    public init(entity: DrawingPencilObjectEntity) {
        lineWidth = entity.lineWidth
        super.init(data: entity)
    }
    
    public init(
        object: DrawingPencilObjectData
    ) {
        self.lineWidth = object.lineWidth
        super.init(data: object.data)
    }

    public func onUpdate(
        _ trajectory: [Coordinate],
        _ start: Coordinate,
        _ end: Coordinate
    ) {
        data.trajectory = trajectory
        super.onUpdate(start, end)
    }

    public static func create(
        _ setting: DrawingSettingData,
        _ start: Coordinate,
        _ end: Coordinate
    ) -> DrawingPencilObjectData {
        .init(entity: .init(
            id: UUID(),
            type: .pencil,
            state: .created,
            start: start,
            end: end,
            color: setting.color,
            lineWidth: setting.lineWidth,
            trajectory: [start]
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
    
    public init(
        object: DrawingArrowObjectData
    ) {
        self.lineWidth = object.lineWidth
        super.init(data: object.data)
    }

    public static func create(
        _ setting: DrawingSettingData,
        _ start: Coordinate,
        _ end: Coordinate
    ) -> DrawingArrowObjectData {
        .init(entity: .init(
            id: UUID(),
            type: .arrowLine,
            state: .created,
            start: start,
            end: end,
            color: setting.color,
            lineWidth: setting.lineWidth,
            trajectory: [start]
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
    
    public init(
        object: DrawingRectangleObjectData
    ) {
        self.lineWidth = object.lineWidth
        super.init(data: object.data)
    }
    
    public static func create(
        _ setting: DrawingSettingData,
        _ start: Coordinate,
        _ end: Coordinate
    ) -> DrawingRectangleObjectData {
        .init(entity: .init(
            id: UUID(),
            type: .rectangle,
            state: .created,
            start: start,
            end: end,
            color: setting.color,
            lineWidth: setting.lineWidth,
            trajectory: [start]
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
    
    public init(
        object: DrawingCircleObjectData
    ) {
        self.lineWidth = object.lineWidth
        super.init(data: object.data)
    }
    
    public static func create(
        _ setting: DrawingSettingData,
        _ start: Coordinate,
        _ end: Coordinate
    ) -> DrawingCircleObjectData {
        .init(entity: .init(
            id: UUID(),
            type: .circle,
            state: .created,
            start: start,
            end: end,
            color: setting.color,
            lineWidth: setting.lineWidth,
            trajectory: [start]
        ))
    }
}

/// 楕円
public class DrawingOvalObjectData: DrawingObjectData {
    public var lineWidth: Double

    public init(entity: DrawingOvalObjectEntity) {
        lineWidth = entity.lineWidth
        super.init(data: entity)
    }
    
    public init(
        object: DrawingOvalObjectData
    ) {
        self.lineWidth = object.lineWidth
        super.init(data: object.data)
    }
    
    public static func create(
        _ setting: DrawingSettingData,
        _ start: Coordinate,
        _ end: Coordinate
    ) -> DrawingOvalObjectData {
        .init(entity: .init(
            id: UUID(),
            type: .circle,
            state: .created,
            start: start,
            end: end,
            color: setting.color,
            lineWidth: setting.lineWidth,
            trajectory: [start]
        ))
    }
}
/// テキスト
public class DrawingTextObjectData: DrawingObjectData {
    public var backgroundColor: DrawingObjectColor
    public var text: String

    public init(entity: DrawingTextObjectEntity) {
        backgroundColor = entity.backgroundColor
        text = entity.text
        super.init(data: entity)
    }
    
    public init(
        object: DrawingTextObjectData
    ) {
        self.backgroundColor = object.backgroundColor
        self.text = object.text
        super.init(data: object.data)
    }
    
    public static func create(
        _ setting: DrawingSettingData,
        _ start: Coordinate,
        _ end: Coordinate,
        _ trajectory: [Coordinate]
    ) -> DrawingTextObjectData {
        .init(entity: .init(
            id: UUID(),
            type: .text,
            state: .created,
            start: start,
            end: end,
            color: setting.color,
            backgroundColor: getBackgroudColor(setting.color),
            text: setting.text,
            trajectory: trajectory
        ))
    }
    
    public static func getBackgroudColor(
        _ textColor: DrawingObjectColor
    ) -> DrawingObjectColor {
        switch textColor {
        case .blue:
            return .green
        case .green:
            return .magenta
        case .magenta:
            return .red
        case .red:
            return .yellow
        case .yellow:
            return .green
        }
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
    func asOval() -> DrawingOvalObjectData? {
        self as? DrawingOvalObjectData
    }
    func asText() -> DrawingTextObjectData? {
        self as? DrawingTextObjectData
    }
}

public extension DrawingObjectColor {
    var toUIColor: Color { .init(hex: rawValue) }
}

public extension [DrawingObjectData] {
    func copy() -> [DrawingObjectData] {
        var objects = [DrawingObjectData]()
         
        forEach { object in
            if let object = object.asPencil() {
                objects.append(DrawingPencilObjectData(object: object))
            } else if let object = object.asArrow() {
                objects.append(DrawingArrowObjectData(object: object))
            } else if let object = object.asRectangle() {
                objects.append(DrawingRectangleObjectData(object: object))
            } else if let object = object.asCircle() {
                objects.append(DrawingCircleObjectData(object: object))
            } else if let object = object.asText() {
                objects.append(DrawingTextObjectData(object: object))
            }
        }
        return objects
    }
}
