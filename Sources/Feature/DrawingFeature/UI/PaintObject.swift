//
//  PaintObject.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/23.
//

import SwiftUI
import Repository // for DrawingObject

public struct PaintObject: View {
    private var object: DrawingObject
    
    public init(object: DrawingObject) {
        self.object = object
    }

    public var body: some View {
        Path { path in
            path.move(to: object.start)
            path.addLine(to: object.end)
        }
        .stroke(Color.red, lineWidth: object.lineWidth)
    }
}
