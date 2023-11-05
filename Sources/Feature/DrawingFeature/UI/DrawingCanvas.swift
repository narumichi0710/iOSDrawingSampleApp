//
//  DrawingCanvas.swift
//
//
//  Created by Narumichi Kubo on 2023/09/17.
//

import SwiftUI
import Service
import Repository
import ViewExtension

public struct DrawingCanvas: View {
    private let setting: DrawingSettingData
    @ObservedObject private var layer: DrawingLayerData

    public init(setting: DrawingSettingData, layer: DrawingLayerData) {
        self.setting = setting
        self.layer = layer
    }
    
    public var body: some View {
        ZStack {
            // 編集済のオブジェクト
            ForEach(layer.objects, id: \.id) {
                DrawingObject(object: $0)
            }
            // 編集中のオブジェクト
            if let objects = layer.editingObject {
                DrawingObject(object: objects)
            }
            // 描画用オーバーレイ
            gestureOverlay()
        }
    }

    private func gestureOverlay() -> some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0.1)
                    .onChanged {
                        guard let object = layer.editingObject else {
                            onCreatedDrawing(.init(x: $0.location.x, y: $0.location.y))
                            return
                        }
                        onUpdatedDrawing(object, .init(x: $0.location.x, y: $0.location.y))
                    }.onEnded {
                        onEndedDrawing(.init(x: $0.location.x, y: $0.location.y))
                    }
            )
    }

    private func onCreatedDrawing(_ coordinate: Coordinate) {
        switch setting.type {
        case .pencil:
            layer.editingObject = DrawingPencilObjectData.create(setting, coordinate)
        case .arrowLine:
            layer.editingObject = DrawingArrowObjectData.create(setting, coordinate)
        default: break
        }
        layer.apply()
    }

    private func onUpdatedDrawing(_ object: DrawingObjectData, _ coordinate: Coordinate) {
        if let object = object.asPencil() {
            object.onCreatePath(coordinate)
        } else if let objects = object.asArrow() {
            object.onEnd(coordinate)
        }
        layer.apply()
    }

    private func onEndedDrawing(_ coordinate: Coordinate) {
        layer.editingObject?.onEnd(coordinate)
        layer.appendEditingObject()
        layer.apply()
    }
}
