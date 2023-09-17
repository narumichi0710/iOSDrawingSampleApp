//
//  DrawingList.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import Foundation

public struct DrawingList: Codable {
    public var id: UUID
    public var name: String
    public var created: Date
    public var updated: Date?
    public var deleted: Data?
    public var drawingInfos: [DrawingInfo]
    
    public init(id: UUID, name: String, created: Date, updated: Date? = nil, deleted: Data? = nil, drawingInfos: [DrawingInfo]) {
        self.id = id
        self.name = name
        self.created = created
        self.updated = updated
        self.deleted = deleted
        self.drawingInfos = drawingInfos
    }

    static let mockDrawingList = DrawingList(
        id: UUID(),
        name: "mockDrawingList",
        created: .now,
        updated: nil,
        deleted: nil,
        drawingInfos: [
            .init(id: UUID(), name: "drawing_1"),
            .init(id: UUID(), name: "drawing_2"),
            .init(id: UUID(), name: "drawing_3")
        ]
    )
}

public struct DrawingInfo: Codable {
    public var id: UUID
    public var name: String
    
    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

public struct Drawing: Codable {
    public var id: UUID
    public var name: String
    public var created: Date
    public var updated: Date?
    public var deleted: Data?

    public init(id: UUID, name: String, created: Date, updated: Date? = nil, deleted: Data? = nil) {
        self.id = id
        self.name = name
        self.created = created
        self.updated = updated
        self.deleted = deleted
    }
    
    static let mockDrawing = Drawing(
        id: UUID(),
        name: "mockDrawing",
        created: .now,
        updated: nil,
        deleted: nil
    )
}
