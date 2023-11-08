//
//  DrawingCanvas.swift
//
//
//  Created by Narumichi Kubo on 2023/11/06.
//

import SwiftUI
import Service
import ViewExtension
import Repository

public struct DrawingCanvas: View {
    @Binding private var isShowCoordinate: Bool
    @Binding private var currentCoordinate: String
    
    @Binding private var setting: DrawingSettingData
    @ObservedObject private var layer: DrawingLayerData
    private let geometryProxy: GeometryProxy

    @State private var isShowExternalOverlay = false    

    @State private var previousTime: TimeInterval = .zero
    
    public init(
        geometryProxy: GeometryProxy,
        setting: Binding<DrawingSettingData>,
        layer: DrawingLayerData,
        isShowCoordinate: Binding<Bool>,
        currentCoordinate: Binding<String>
    ) {
        _setting = setting
        _isShowCoordinate = isShowCoordinate
        _currentCoordinate = currentCoordinate
        self.geometryProxy = geometryProxy
        self.layer = layer
    }
    
    public var body: some View {
        ZStack {
            // デバッグ用の座標グリッド
            if isShowCoordinate {
                coordinateGrid()
            }
            // 編集済のオブジェクト
            ForEach(layer.objects, id: \.id) {
                LocalDrawingObject(object: $0)
            }
            // 編集中のオブジェクト
            if let objects = layer.editingObject {
                LocalDrawingObject(object: objects)
            }
            // 描画用オーバーレイ
            gestureOverlay()
        }
        // その他のオーバーレイ
        if isShowExternalOverlay {
            externalOverlay()
        }
    }

    private func gestureOverlay() -> some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0.0)
                    .onChanged {
                        let currentTime = $0.time.timeIntervalSince1970
                        let interval = previousTime == .zero ? 0.0 : currentTime - previousTime
                        let coordinate = Coordinate(x: $0.location.x, y: $0.location.y, interval: interval)

                        if $0.startLocation == $0.location {
                            onTapedCanvas(coordinate)
                        } else {
                            guard let object = layer.editingObject else {
                                onCreatedDrawing(coordinate)
                                return
                            }
                            onUpdatedDrawing(object, coordinate)
                        }
                        previousTime = currentTime
                        currentCoordinate = "x: \(Int($0.location.x)), y: \(Int($0.location.y))"
                    }.onEnded {
                        let coordinate = Coordinate(x: $0.location.x, y: $0.location.y)
                        onEndedDrawing(coordinate)
                    }
            )
    }
    
    private func externalOverlay() -> some View {
        Group {
            switch setting.type {
            case .text:
                Color.clear
                    .fullScreenCover(isPresented: $isShowExternalOverlay) {
                        TextInputView(
                            textColor: setting.color,
                            backgroundColor: DrawingTextObjectData.getBackgroudColor(setting.color)
                        ) {
                            if !$0.isEmpty {
                                setting.text = $0
                                layer.append(DrawingTextObjectData.create(setting, setting.tmpCoordinate))
                            }
                            isShowExternalOverlay = false
                        }
                        .setBackgroundClear()
                    }

            default: EmptyView()
            }
        }
        .ignoresSafeArea(.all)
    }
    
    private func coordinateGrid() -> some View {
        let size = geometryProxy.size
        let gridSpacingX = max(50, size.width / 20)
        let gridSpacingY = max(50, size.height / 20)
        
        return ZStack {
            // x軸
            ForEach(0..<Int(size.width / gridSpacingX), id: \.self) { index in
                let positionX = CGFloat(index) * gridSpacingX
                if positionX <= size.width {
                    Path { path in
                        path.move(to: CGPoint(x: positionX, y: 0))
                        path.addLine(to: CGPoint(x: positionX, y: size.height))
                    }
                    .stroke(Color.black, lineWidth: 1)
                    
                    Text("\(index * Int(gridSpacingX))")
                        .font(.caption)
                        .foregroundColor(.black)
                        .position(x: positionX, y: -10)
                }
            }
            
            // y軸
            ForEach(0..<Int(size.height / gridSpacingY), id: \.self) { index in
                let positionY = CGFloat(index) * gridSpacingY
                if positionY <= size.height {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: positionY))
                        path.addLine(to: CGPoint(x: size.width, y: positionY))
                    }
                    .stroke(Color.black, lineWidth: 1)
                    
                    Text("\(index * Int(gridSpacingY))")
                        .font(.caption)
                        .foregroundColor(.black)
                        .position(x: -14, y: positionY)
                }
            }
        }
    }

    
    private func onTapedCanvas(_ coordinate: Coordinate) {
        switch setting.type {
        case .text:
            withAnimation {
                isShowExternalOverlay = true
            }
            setting.tmpCoordinate = coordinate
        default: break
        }
    }
    
    private func onCreatedDrawing(_ coordinate: Coordinate) {
        switch setting.type {
        case .pencil:
            layer.editingObject =  DrawingPencilObjectData.create(setting, coordinate)
        case .arrowLine:
            layer.editingObject = DrawingArrowObjectData.create(setting, coordinate)
        case .rectangle:
            layer.editingObject = DrawingRectangleObjectData.create(setting, coordinate)
        case .circle:
            layer.editingObject = DrawingCircleObjectData.create(setting, coordinate)
        default:
            break
        }
        layer.apply()
    }

    private func onUpdatedDrawing(_ object: DrawingObjectData, _ coordinate: Coordinate) {
        // 軌跡を追加
        object.onAddRrajectory(coordinate)

        if object.asPencil() != nil {
            object.onEnd(coordinate)
        } else if object.asArrow() != nil {
            object.onEnd(coordinate)
        } else if object.asRectangle() != nil {
            object.onEnd(coordinate)
        } else if object.asCircle() != nil {
            object.onEnd(coordinate)
        }
        layer.apply()
    }

    private func onEndedDrawing(_ coordinate: Coordinate) {
        layer.editingObject?.onEnd(coordinate)
        layer.appendEditingObject()
        layer.apply()
        
        previousTime = .zero
    }
}
