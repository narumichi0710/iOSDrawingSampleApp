//
//  DrawingListHistory.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import Foundation

public struct DrawingListHistory: Codable {
    public var id: UUID
    public var name: String
    public var created: Date
    public var updated: Date?
    public var deleted: Data?
    public var histories: [DrawingHistory]
    
    public init(id: UUID, name: String, created: Date, updated: Date? = nil, deleted: Data? = nil, histories: [DrawingHistory]) {
        self.id = id
        self.name = name
        self.created = created
        self.updated = updated
        self.deleted = deleted
        self.histories = histories
    }
    
    static let mockDrawingListHistory = DrawingListHistory(
        id: UUID(),
        name: "mockDrawingListHistory",
        created: .now,
        updated: nil,
        deleted: nil,
        histories: []
    )
}

public struct DrawingHistory: Codable {
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
    
    static let mockDrawingListHistory = DrawingHistory(
        id: UUID(),
        name: "mockDrawingListHistory",
        created: .now,
        updated: nil,
        deleted: nil
    )
}
