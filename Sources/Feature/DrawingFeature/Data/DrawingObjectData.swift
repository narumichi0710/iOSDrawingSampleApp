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
    public var color: DrawingObjectColor { data.color }
    public var type: DrawingObjectType { data.type }
    public var state: DrawingObjectState { data.state }
    
    @Published private var modified: Date = .now

    func updateState(_ value: DrawingObjectState) {
        data.state = value
    }
    
    func apply() {
        modified = .now
    }

    public init(data: DrawingObjectProperty) {
        self.data = data
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

    public static func create(_ setting: DrawingSettingData) -> DrawingPencilObjectData {
        .init(entity: .init(
            id: UUID(),
            type: .pencil,
            state: .created,
            start: .init(),
            end: .init(),
            color: setting.color,
            points: .init(),
            lineWidth: setting.lineWidth
        ))
    }
}


public extension DrawingObjectData {
    func asPencil() -> DrawingPencilObjectData? {
        self as? DrawingPencilObjectData
    }
}

public extension DrawingObjectColor {
    var toUIColor: Color { .init(hex: rawValue) }
}
