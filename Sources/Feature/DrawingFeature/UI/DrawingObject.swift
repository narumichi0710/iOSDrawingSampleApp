//
//  DrawingObject.swift
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
        } else if let object = object.asArrow() {
            ArrowObject(object: object)
        } else if let object = object.asRectangle() {
            RectangleObject(object: object)
        }
    }
}

/// ペン
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

/// 矢印
public struct ArrowObject: View {
    @ObservedObject var object: DrawingArrowObjectData
    /// 矢印の先の長さ
    let arrowLength: CGFloat = 24.0
    /// 角度（45度）
    let arrowAngle: CGFloat = .pi / 4
    
    public var body: some View {
        Path { path in
            // 線の描画
            path.move(to: object.start.cgPoint)
            path.addLine(to: object.end.cgPoint)
           
            // 角度の計算
            let dx = object.end.x - object.start.x
            let dy = object.end.y - object.start.y
            let theta = atan2(dy, dx)

            // 矢印の羽の点を計算
            let wing1 = CGPoint(
                x: object.start.x + arrowLength * cos(theta + arrowAngle),
                y: object.start.y + arrowLength * sin(theta + arrowAngle)
            )
            let wing2 = CGPoint(
                x: object.start.x + arrowLength * cos(theta - arrowAngle),
                y: object.start.y + arrowLength * sin(theta - arrowAngle)
            )
           
            // 矢印の羽を描画
            path.move(to: wing1)
            path.addLine(to: object.start.cgPoint)
            path.addLine(to: wing2)
        }
        .stroke(object.color.toUIColor, lineWidth: object.lineWidth)
    }
}

/// 矩形
public struct RectangleObject: View {
    @ObservedObject var object: DrawingRectangleObjectData

    public var body: some View {
        Path { path in
            let rect = CGRect(
                x: min(object.start.x, object.end.x),
                y: min(object.start.y, object.end.y),
                width: abs(object.start.x - object.end.x),
                height: abs(object.start.y - object.end.y)
            )
            path.addRect(rect)
        }
        .stroke(object.color.toUIColor, lineWidth: object.lineWidth)
    }
}
