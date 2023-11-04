//
//  DrawingLayerEntity.swift
//
//
//  Created by Narumichi Kubo on 2023/11/04.
//

import Foundation

public struct DrawingLayerEntity: Codable {
    public var id: UUID
    public var pencilObjects: [DrawingPencilObjectEntity]

    public init(
        id: UUID = UUID(),
        pencilObjects: [DrawingPencilObjectEntity] = []
    ) {
        self.id = id
        self.pencilObjects = pencilObjects
    }
}
