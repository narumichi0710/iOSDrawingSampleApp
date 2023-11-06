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
import UIKit

public struct DrawingCanvas: View {
    @Binding private var setting: DrawingSettingData
    @ObservedObject private var layer: DrawingLayerData
    @State private var isShowExternalOverlay = false

    public init(setting: Binding<DrawingSettingData>, layer: DrawingLayerData) {
        _setting = setting
        self.layer = layer
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { geo in
                // 編集済のオブジェクト
                ForEach(layer.objects, id: \.id) {
                    DrawingObject(object: $0)
                }
                // 編集中のオブジェクト
                if let objects = layer.editingObject {
                    DrawingObject(object: objects)
                }
                // 描画用オーバーレイ
                gestureOverlay(geo)
            }
        }
        // その他のオーバーレイ
        if isShowExternalOverlay {
            externalOverlay()
        }
    }

    private func gestureOverlay(_ geo: GeometryProxy) -> some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0.0)
                    .onChanged {
                        if $0.startLocation == $0.location {
                            onTapedCanvas(.init(x: $0.location.x, y: $0.location.y))
                        } else {
                            guard let object = layer.editingObject else {
                                onCreatedDrawing(.init(x: $0.location.x, y: $0.location.y))
                                return
                            }
                            onUpdatedDrawing(object, .init(x: $0.location.x, y: $0.location.y))
                        }
                    }.onEnded {
                        onEndedDrawing(.init(x: $0.location.x, y: $0.location.y))
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
                            withAnimation {
                                isShowExternalOverlay = false
                            }
                            setting.text = $0
                            
                            if !$0.isEmpty {
                                let object = DrawingTextObjectData.create(setting, setting.tmpCoordinate)
                                layer.append(object)
                                withAnimation {
                                    layer.apply()
                                }
                            }
                        }
                        .setBackgroundClear()
                    }

            default: EmptyView()
            }
        }
        .ignoresSafeArea(.all)
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
            layer.editingObject = DrawingPencilObjectData.create(setting, coordinate)
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
        if let object = object.asPencil() {
            object.onCreatePath(coordinate)
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
    }
}
