//
//  DrawingList.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import Foundation
import SwiftUI

public struct DrawingList: Codable {
    public var id: UUID
    public var name: String
    public var created: Date
    public var updated: Date?
    public var deleted: Data?
    public var layerInfos: [DrawingLayerInfo]
    
    public init(
        id: UUID,
        name: String,
        created: Date,
        updated: Date? = nil,
        deleted: Data? = nil,
        layerInfos: [DrawingLayerInfo]
    ) {
        self.id = id
        self.name = name
        self.created = created
        self.updated = updated
        self.deleted = deleted
        self.layerInfos = layerInfos
    }

    public static let mockDrawingList = DrawingList(
        id: UUID(),
        name: "mockDrawingList",
        created: .now,
        updated: nil,
        deleted: nil,
        layerInfos: DrawingLayerInfo.mockLayerInfos
    )
}

public struct DrawingLayerInfo: Codable {
    public var id: UUID
    public var name: String
    
    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    public static let mockLayerInfos: [DrawingLayerInfo] = [
        mockDrawingInfo(0),
        mockDrawingInfo(1),
        mockDrawingInfo(2)
    ]
    
    static func mockDrawingInfo(_ index: Int) -> DrawingLayerInfo {
        .init(
            id: DrawingLayer.mockDrawings[index].id,
            name: DrawingLayer.mockDrawings[index].name
        )
    }
}

public struct DrawingLayer: Codable {
    public var id: UUID
    public var name: String
    public var frame: CGRect
    public var objects: [DrawingObject]
    public var created: Date
    public var updated: Date?
    public var deleted: Data?

    public init(
        id: UUID,
        name: String,
        frame: CGRect,
        objects: [DrawingObject],
        created: Date,
        updated: Date? = nil,
        deleted: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.frame = frame
        self.objects = objects
        self.created = created
        self.updated = updated
        self.deleted = deleted
    }
        
    public static func create(
        _ id: UUID,
        _ name: String
    ) -> DrawingLayer {
        .init(
            id: id,
            name: name,
            frame: .zero,
            objects: [],
            created: .now
        )
    }

    static var ids = [UUID(), UUID(), UUID()]
    
    public static let mockDrawings: [DrawingLayer] = [
        .init(
            id: UUID(),
            name: "drawing_1",
            frame: .zero,
            objects: [],
            created: .now,
            updated: nil,
            deleted: nil
        ),
        .init(
            id: UUID(),
            name: "drawing_2",
            frame: .zero,
            objects: [],
            created: .now,
            updated: nil,
            deleted: nil
        ),
        .init(
            id: UUID(),
            name: "drawing_3",
            frame: .zero,
            objects: [],
            created: .now,
            updated: nil,
            deleted: nil
        ),
    ]
}

public struct DrawingObject: Codable {
    public var id: UUID
    public var type: Int
    public var start: CGPoint
    public var end: CGPoint
    public var lineWidth: CGFloat
    
    public init(id: UUID, type: Int, start: CGPoint, end: CGPoint, lineWidth: CGFloat) {
        self.id = id
        self.type = type
        self.start = start
        self.end = end
        self.lineWidth = lineWidth
    }
    
    public static func create() -> DrawingObject {
        .init(
            id: UUID(),
            type: 0,
            start: .zero,
            end: .zero,
            lineWidth: 2
        )
    }
}
