//
//  DrawingInteractor.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import Foundation
import SwiftUI
import Service
import Repository

public class DrawingInteractor: ObservableObject {
    let drawingService: DrawingService
    let file: File
    
    @Published var setting = DrawingSettingData()
    @Published var layer = DrawingLayerData()
    
    public init(drawingService: DrawingService, file: File) {
        self.drawingService = drawingService
        self.file = file
    }
    
    public func changeDrawingType(_ value: DrawingObjectType) {
        setting.type = value
    }
    
    public func changeDrawingColor(_ value: DrawingObjectColor) {
        setting.color = value
    }
    
    public func convertCoordinates(_ newCanvasSize: CGSize) {
        let oldCanvasSize = setting.canvasSize
        setting.canvasSize = newCanvasSize
    
        let normalizedLayer = convertToImageCoordinates(layer, setting.imageSize, oldCanvasSize)
        let adjustedLayer = convertToCanvasCoordinates(normalizedLayer, setting.imageSize, newCanvasSize)
        
        layer = adjustedLayer
    }
    
    /// キャンバス座標を画像座標に変換
    public func convertToImageCoordinates(
        _ layer: DrawingLayerData,
        _ imageSize: CGSize,
        _ canvasSize: CGSize
    ) -> DrawingLayerData {
        let applyLayer = layer
        // キャンバスと画像のサイズ比
        let xRatio = imageSize.width / canvasSize.width
        let yRatio = imageSize.height / canvasSize.height

        applyLayer.objects.forEach { object in
            // 変換した開始・終了座標
            let adjustedStart = scaleCoordinateByRatio(object.start, xRatio, yRatio)
            let adjustedEnd = scaleCoordinateByRatio(object.end, xRatio, yRatio)

            // ペンシルオブジェクトの場合、点の集合も変換
            if let pencilObject = object.asPencil() {
                let adjustedPoints = pencilObject.points.map { scaleCoordinateByRatio($0, xRatio, yRatio) }
                pencilObject.onUpdate(adjustedPoints, adjustedStart, adjustedEnd)
            } else {
                object.onUpdate(adjustedStart, adjustedEnd)
            }
        }
        return applyLayer
    }

    /// 画像座標をキャンバス座標に変換
    public func convertToCanvasCoordinates(
        _ layer: DrawingLayerData,
        _ imageSize: CGSize,
        _ canvasSize: CGSize
    ) -> DrawingLayerData {
        let applyLayer = layer
        // キャンバスと画像のサイズ比を計算
        let xRatio = canvasSize.width / imageSize.width
        let yRatio = canvasSize.height / imageSize.height

        applyLayer.objects.forEach { object in
            // 変換した開始・終了座標
            let adjustedStart = scaleCoordinateByRatio(object.start, xRatio, yRatio)
            let adjustedEnd = scaleCoordinateByRatio(object.end, xRatio, yRatio)

            // ペンシルオブジェクトの場合、点の集合も変換
            if let pencilObject = object.asPencil() {
                let adjustedPoints = pencilObject.points.map { scaleCoordinateByRatio($0, xRatio, yRatio) }
                pencilObject.onUpdate(adjustedPoints, adjustedStart, adjustedEnd)
            } else {
                object.onUpdate(adjustedStart, adjustedEnd)
            }
        }
        
        return applyLayer
    }
    
    /// 座標をスケール比に応じて調整
    private func scaleCoordinateByRatio(
        _ coordinate: Coordinate,
        _ xRatio: CGFloat,
        _ yRatio: CGFloat
    ) -> Coordinate {
        Coordinate(
            x: coordinate.x * xRatio,
            y: coordinate.y * yRatio
        )
    }
}
