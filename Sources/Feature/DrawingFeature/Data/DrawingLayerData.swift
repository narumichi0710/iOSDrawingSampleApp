//
//  DrawingLayerData.swift
//
//
//  Created by Narumichi Kubo on 2023/11/04.
//

import SwiftUI
import Service
import Repository

public class DrawingLayerData: Equatable, ObservableObject {
    public var id: UUID
    public var objects: [DrawingObjectData]
    public var editingObject: DrawingObjectData?
    
    @Published private var modified: Date = .now

    public init(id: UUID = UUID(), objects: [DrawingObjectData] = []) {
        self.id = id
        self.objects = objects
    }

    public init(_ entity: DrawingLayerEntity) {
        var objects = [DrawingObjectData]()
        let pencils = entity.pencilObjects.map { DrawingPencilObjectData(entity: $0) }
        objects.append(contentsOf: pencils)

        self.id = entity.id
        self.objects = objects
    }

    // MARK: レイヤー系
    
    public func appendEditingObject() {
        if let editingObject { append(editingObject) }
        editingObject = nil
    }
    
    
    public func update(_ layer: DrawingLayerData) {
        layer.objects.forEach { newObject in
            if let index = objects.firstIndex(where: { $0.id == newObject.id }) {
                objects[index] = newObject
            } else {
                objects.append(newObject)
            }
        }
    }
    
    public func apply() {
        modified = .now
    }

    public func reset() {
        objects.removeAll()
        apply()
    }
    
    public func copy() -> DrawingLayerData {
        .init(id: UUID(), objects: objects.copy())
    }

    // MARK: オブジェクト系

    public func append(_ object: DrawingObjectData) {
        objects.append(object)
    }
    
    public func update(_ object: DrawingObjectData) {
        guard let index = objects.firstIndex(where: { $0.id == object.id }) else { return }
        objects[index] = object
    }
    
    public func delete(id: UUID) {
        guard let index = objects.firstIndex(where: { $0.id == id }) else { return }
        objects[index].updateState(.deleted)
    }
    

    public static func == (lhs: DrawingLayerData, rhs: DrawingLayerData) -> Bool {
        lhs.id == rhs.id
    }
}

public extension DrawingLayerData {
    func toEntity() -> DrawingLayerEntity {
        var pencilEntities = [DrawingPencilObjectEntity]()
        var arrowEntities = [DrawingArrowObjectEntity]()
        var rectangleEntities = [DrawingRectangleObjectEntity]()
        var circleEntities = [DrawingCircleObjectEntity]()
        var textEntities = [DrawingTextObjectEntity]()
        
        objects.forEach {
            switch $0.data {
            case let pencilObject as DrawingPencilObjectEntity:
                pencilEntities.append(pencilObject)
            case let arrowObject as DrawingArrowObjectEntity:
                arrowEntities.append(arrowObject)
            case let rectangleObject as DrawingRectangleObjectEntity:
                rectangleEntities.append(rectangleObject)
            case let circleObject as DrawingCircleObjectEntity:
                circleEntities.append(circleObject)
            case let textObject as DrawingTextObjectEntity:
                textEntities.append(textObject)
            default:
                break
            }
        }

        return .init(
            id: id,
            pencilObjects: pencilEntities,
            arrowObjects: arrowEntities,
            rectangleObjects: rectangleEntities,
            circleObjects: circleEntities,
            textObjects: textEntities
        )
    }
}
