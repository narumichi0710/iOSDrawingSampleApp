//
//  PaintObject.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/23.
//

import SwiftUI

public struct DrawingObject: View {
    @ObservedObject private var object: DrawingObjectData

    public init(object: DrawingObjectData) {
        self.object = object
    }

    public var body: some View {
        if let object = object.asPencil() {
            PencilObject(object: object)
        }
    }
}

public struct PencilObject: View {
    @ObservedObject var object: DrawingPencilObjectData
    private var points: [CGPoint] { object.points.map(\.cgPoint) }

    public var body: some View {
        Path { path in
            path.addLines(points)
        }
        .stroke(object.color.toUIColor, lineWidth: object.lineWidth)
    }
}

