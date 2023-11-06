//
//  File.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/17.
//

import Foundation

public struct File {
    public var id: UUID
    public var name: String
    public var imageUrl: String
    
    public init(id: UUID = UUID(), name: String, imageUrl: String = "https://picsum.photos/400") {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
}

public var mockFiles = [
    File(name: "drawing resized image"),
    File(name: "file_2"),
    File(name: "file_3"),
    File(name: "file_4"),
    File(name: "file_5")
]
