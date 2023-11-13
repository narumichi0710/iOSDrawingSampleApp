//
//  DrawingLayerEntity.swift
//
//
//  Created by Narumichi Kubo on 2023/11/04.
//

import Foundation

public struct DrawingLayerEntity: Codable {
    public var id: UUID
    public var pencilObjects: [DrawingPencilObjectEntity]?
    public var arrowObjects: [DrawingArrowObjectEntity]?
    public var rectangleObjects: [DrawingRectangleObjectEntity]?
    public var circleObjects: [DrawingCircleObjectEntity]?
    public var textObjects: [DrawingTextObjectEntity]?

    public init(
        id: UUID = UUID(),
        pencilObjects: [DrawingPencilObjectEntity]? = nil,
        arrowObjects: [DrawingArrowObjectEntity]? = nil,
        rectangleObjects: [DrawingRectangleObjectEntity]? = nil,
        circleObjects: [DrawingCircleObjectEntity]? = nil,
        textObjects: [DrawingTextObjectEntity]? = nil
    ) {
        self.id = id
        self.pencilObjects = pencilObjects
        self.arrowObjects = arrowObjects
        self.rectangleObjects = rectangleObjects
        self.circleObjects = circleObjects
        self.textObjects = textObjects
    }
}
