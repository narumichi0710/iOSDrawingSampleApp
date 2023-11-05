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
                            onCreatedDrawing()
                            return
                        }
                        onUpdatedDrawing(object, .init(x: $0.location.x, y: $0.location.y))
                    }.onEnded { _ in
                        onEndedDrawing()
                    }
            )
    }

    private func onCreatedDrawing() {
        switch setting.type {
        case .pencil:
            layer.editingObject = DrawingPencilObjectData.create(setting)
        default: break
        }
        layer.apply()
    }

    private func onUpdatedDrawing(_ object: DrawingObjectData, _ point: Coordinate) {
        if let object = object.asPencil() {
            object.onCreatePath(point)
        }
        layer.apply()
    }

    private func onEndedDrawing() {
        layer.appendEditingObject()
        layer.apply()
    }
}
