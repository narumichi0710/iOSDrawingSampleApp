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
    public var imageURL: String
    public var created: Date
    public var updated: Date?
    public var deleted: Data?
    public var drawing: [Drawing]
    
    public init(id: UUID, name: String, imageURL: String, created: Date, updated: Date? = nil, deleted: Data? = nil, drawing: [Drawing]) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.created = created
        self.updated = updated
        self.deleted = deleted
        self.drawing = drawing
    }

    static let mockDrawingList = DrawingList(
        id: UUID(),
        name: "mockDrawingList",
        imageURL: "https://picsum.photos/400",
        created: .now,
        updated: nil,
        deleted: nil,
        drawing: [
            .mockDrawing,
            .mockDrawing,
            .mockDrawing
        ]
    )
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
