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
        } else if let object = object.asOval() {
            RemoteOvalObject(object: object)
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
        .onAppear(perform: addTrajectoryWithInterval)
    }
    
    func addTrajectoryWithInterval() {
        Task {
            for coordinate in object.trajectory {
                guard let interval = coordinate.info?.interval else { return }
                let duration = UInt64(interval * 1_000_000_000)
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
    @State var start: CGPoint?
    @State var end: CGPoint?

    /// 矢印の先の長さ
    let arrowLength: CGFloat = 24.0
    /// 角度（45度）
    let arrowAngle: CGFloat = .pi / 4
    
    public var body: some View {
        ZStack {
            if let start, let end {
                Path { path in
                    // 線の描画
                    path.move(to: start)
                    path.addLine(to: end)
                    
                    // 角度の計算
                    let dx = end.x - start.x
                    let dy = end.y - start.y
                    let theta = atan2(dy, dx)
                    
                    // 矢印の羽の点を計算
                    let wing1 = CGPoint(
                        x: start.x + arrowLength * cos(theta + arrowAngle),
                        y: start.y + arrowLength * sin(theta + arrowAngle)
                    )
                    let wing2 = CGPoint(
                        x: start.x + arrowLength * cos(theta - arrowAngle),
                        y: start.y + arrowLength * sin(theta - arrowAngle)
                    )
                    
                    // 矢印の羽を描画
                    path.move(to: wing1)
                    path.addLine(to: start)
                    path.addLine(to: wing2)
                }
                .stroke(object.color.toUIColor, lineWidth: object.lineWidth)
            }
        }
        .onAppear(perform: addTrajectoryWithInterval)
    }
    
    func addTrajectoryWithInterval() {
        Task {
            updateStart(object.start.cgPoint)
            for coordinate in object.trajectory {
                guard let interval = coordinate.info?.interval else { return }
                let duration = UInt64(interval * 1_000_000_000)
                // 指定されたインターバルだけ待機する
                try? await Task.sleep(nanoseconds: duration)
                updateEnd(coordinate.cgPoint)
            }
            updateEnd(object.end.cgPoint)
        }
    }
    
    @MainActor
    func updateStart(_ start: CGPoint) {
        withAnimation {
            self.start = start
        }
    }
    
    @MainActor
    func updateEnd(_ end: CGPoint) {
        withAnimation {
            self.end = end
        }
    }
}

/// 矩形
public struct RemoteRectangleObject: View {
    @ObservedObject var object: DrawingRectangleObjectData

    @State var start: CGPoint?
    @State var end: CGPoint?
    
    public var body: some View {
        ZStack {
            if let start, let end {
                Path { path in
                    let rect = CGRect(
                        x: min(start.x, end.x),
                        y: min(start.y, end.y),
                        width: abs(start.x - end.x),
                        height: abs(start.y - end.y)
                    )
                    path.addRect(rect)
                }
                .stroke(object.color.toUIColor, lineWidth: object.lineWidth)
            }
        }
        .onAppear(perform: addTrajectoryWithInterval)
    }
    
    func addTrajectoryWithInterval() {
        Task {
            updateStart(object.start.cgPoint)
            for coordinate in object.trajectory {
                guard let interval = coordinate.info?.interval else { return }
                let duration = UInt64(interval * 1_000_000_000)
                // 指定されたインターバルだけ待機する
                try? await Task.sleep(nanoseconds: duration)
                updateEnd(coordinate.cgPoint)
            }
            updateEnd(object.end.cgPoint)
        }
    }
    
    @MainActor
    func updateStart(_ start: CGPoint) {
        withAnimation {
            self.start = start
        }
    }
    
    @MainActor
    func updateEnd(_ end: CGPoint) {
        withAnimation {
            self.end = end
        }
    }
}

/// 円
public struct RemoteCircleObject: View {
    @ObservedObject var object: DrawingCircleObjectData

    @State var start: CGPoint?
    @State var end: CGPoint?
    
    public var body: some View {
        ZStack {
            if let start, let end {
                Path { path in
                    // 始点と終点の中間点を計算（円の中心点）
                    let centerX = (start.x + end.x) / 2
                    let centerY = (start.y + end.y) / 2
                    let center = CGPoint(x: centerX, y: centerY)
                    
                    // 始点と終点の距離を計算（円の直径）
                    let diameter = sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2))
                    let radius = diameter / 2
                    
                    // 中心点と半径を使って円を追加
                    path.addEllipse(in: CGRect(x: center.x - radius, y: center.y - radius, width: diameter, height: diameter))
                }
                .stroke(object.color.toUIColor, lineWidth: object.lineWidth)
            }
        }
        .onAppear(perform: addTrajectoryWithInterval)
    }
    
    func addTrajectoryWithInterval() {
        Task {
            updateStart(object.start.cgPoint)
            for coordinate in object.trajectory {
                guard let interval = coordinate.info?.interval else { return }
                let duration = UInt64(interval * 1_000_000_000)
                // 指定されたインターバルだけ待機する
                try? await Task.sleep(nanoseconds: duration)
                updateEnd(coordinate.cgPoint)
            }
            updateEnd(object.end.cgPoint)
        }
    }
    
    @MainActor
    func updateStart(_ start: CGPoint) {
        withAnimation {
            self.start = start
        }
    }
    
    @MainActor
    func updateEnd(_ end: CGPoint) {
        withAnimation {
            self.end = end
        }
    }
}


/// 楕円
public struct RemoteOvalObject: View {
    @ObservedObject var object: DrawingOvalObjectData

    @State var start: CGPoint?
    @State var end: CGPoint?
    
    public var body: some View {
        ZStack {
            if let start, let end {
                Path { path in
                    let rect = CGRect(
                        x: min(start.x, end.x),
                        y: min(start.y, end.y),
                        width: abs(start.x - end.x),
                        height: abs(start.y - end.y)
                    )
                    path.addEllipse(in: rect)
                }
                .stroke(object.color.toUIColor, lineWidth: object.lineWidth)
            }
        }
        .onAppear(perform: addTrajectoryWithInterval)
    }
    
    func addTrajectoryWithInterval() {
        Task {
            updateStart(object.start.cgPoint)
            for coordinate in object.trajectory {
                guard let interval = coordinate.info?.interval else { return }
                let duration = UInt64(interval * 1_000_000_000)
                // 指定されたインターバルだけ待機する
                try? await Task.sleep(nanoseconds: duration)
                updateEnd(coordinate.cgPoint)
            }
            updateEnd(object.end.cgPoint)
        }
    }
    
    @MainActor
    func updateStart(_ start: CGPoint) {
        withAnimation {
            self.start = start
        }
    }
    
    @MainActor
    func updateEnd(_ end: CGPoint) {
        withAnimation {
            self.end = end
        }
    }
}

/// テキスト
public struct RemoteTextObject: View {
    @ObservedObject var object: DrawingTextObjectData
    @State var text: String?

    public var body: some View {
        ZStack {
            if let text {
                Text(text)
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
        .onAppear(perform: addTrajectoryWithInterval)
    }
    
    func addTrajectoryWithInterval() {
        Task {
            for coordinate in object.trajectory {
                guard let interval = coordinate.info?.interval else { return }
                guard let text = coordinate.info?.text else { return }

                let duration = UInt64(interval * 1_000_000_000)
                // 指定されたインターバルだけ待機する
                try? await Task.sleep(nanoseconds: duration)
                updateText(text)
            }
        }
    }
    
    @MainActor
    func updateText(_ value: String) {
        text = value
    }
}
