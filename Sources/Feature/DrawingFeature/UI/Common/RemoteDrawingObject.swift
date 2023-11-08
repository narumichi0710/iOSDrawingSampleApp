//
//  RemoteDrawingObject.swift
//  
//
//  Created by Narumichi Kubo on 2023/11/08.
//

import SwiftUI
import Repository



public struct RemoteDrawingObject: View {
    @ObservedObject private var object: DrawingObjectData

    public init(object: DrawingObjectData) {
        self.object = object
    }

    public var body: some View {
        if let object = object.asPencil() {
            RemotePencilObject(object: object)
        } else if let object = object.asArrow() {
            RemoteArrowObject(object: object)
        } else if let object = object.asRectangle() {
            RemoteRectangleObject(object: object)
        } else if let object = object.asCircle() {
            RemoteCircleObject(object: object)
        } else if let object = object.asText() {
            RemoteTextObject(object: object)
        }
    }
}

/// ペン
public struct RemotePencilObject: View {
    @ObservedObject var object: DrawingPencilObjectData
    @State var trajectory = [CGPoint]()

    public var body: some View {
        ZStack {
            Path { path in
                path.addLines(trajectory)
            }
            .stroke(object.color.toUIColor, lineWidth: object.lineWidth)
        }
        .onAppear(perform: addPointsWithInterval)
    }
    
    func addPointsWithInterval() {
        Task {
            for coordinate in object.trajectory {
                let duration = UInt64(coordinate.interval * 1_000_000_000)
                // 指定されたインターバルだけ待機する
                try? await Task.sleep(nanoseconds: duration)
                addTrajectory(coordinate.cgPoint)
            }
        }
    }
       
    @MainActor
    func addTrajectory(_ trajectory: CGPoint) {
        withAnimation {
            self.trajectory.append(trajectory)
        }
    }
}

/// 矢印
public struct RemoteArrowObject: View {
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
public struct RemoteRectangleObject: View {
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

/// 円
public struct RemoteCircleObject: View {
    @ObservedObject var object: DrawingCircleObjectData

    public var body: some View {
        Path { path in
            // 始点と終点の中間点を計算（円の中心点）
            let centerX = (object.start.x + object.end.x) / 2
            let centerY = (object.start.y + object.end.y) / 2
            let center = CGPoint(x: centerX, y: centerY)
            
            // 始点と終点の距離を計算（円の直径）
            let diameter = sqrt(pow(object.end.x - object.start.x, 2) + pow(object.end.y - object.start.y, 2))
            let radius = diameter / 2
            
            // 中心点と半径を使って円を追加
            path.addEllipse(in: CGRect(x: center.x - radius, y: center.y - radius, width: diameter, height: diameter))
        }
        .stroke(object.color.toUIColor, lineWidth: object.lineWidth)
    }
}

/// テキスト
public struct RemoteTextObject: View {
    @ObservedObject var object: DrawingTextObjectData

    public var body: some View {
        Text(object.text)
            .font(.system(size: 20))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(object.backgroundColor.toUIColor)
            )
            .foregroundColor(object.color.toUIColor)
            .position(x: object.start.x, y: object.end.y)
    }
}
