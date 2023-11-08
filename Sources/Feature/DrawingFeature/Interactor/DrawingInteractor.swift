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
    @Published var ndcLayer = DrawingLayerData()

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
    
    
    // MARK: pattarn① canvas ↔︎ image

    public func convertCoordinates_1(_ newCanvasSize: CGSize) {
        let oldCanvasSize = setting.canvasSize
        setting.canvasSize = newCanvasSize
    
        // キャンバス座標を画像座標に変換
        let imageLayer = convertCanvasToImage(layer, setting.imageSize, oldCanvasSize)
        // 画像座標を新しいキャンバス座標に変換
        let newCanvasLayer = convertImageToCanvas(imageLayer, setting.imageSize, newCanvasSize)
    
        layer = newCanvasLayer
    }
    
    /// キャンバス座標を画像座標に変換
    public func convertCanvasToImage(
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

            // ペンの場合、点も変換
            if let pencilObject = object.asPencil() {
                let adjustedCoordinates = pencilObject.points.map { scaleCoordinateByRatio($0, xRatio, yRatio) }
                pencilObject.onUpdate(adjustedCoordinates, adjustedStart, adjustedEnd)
            } else {
                object.onUpdate(adjustedStart, adjustedEnd)
            }
        }
        return applyLayer
    }

    /// 画像座標をキャンバス座標に変換
    public func convertImageToCanvas(
        _ layer: DrawingLayerData,
        _ imageSize: CGSize,
        _ canvasSize: CGSize
    ) -> DrawingLayerData {
        let applyLayer = layer
        // キャンバスと画像のサイズ比
        let xRatio = canvasSize.width / imageSize.width
        let yRatio = canvasSize.height / imageSize.height

        applyLayer.objects.forEach { object in
            // 変換した開始・終了座標
            let adjustedStart = scaleCoordinateByRatio(object.start, xRatio, yRatio)
            let adjustedEnd = scaleCoordinateByRatio(object.end, xRatio, yRatio)

            // ペンの場合、点も変換
            if let pencilObject = object.asPencil() {
                let adjustedCoordinates = pencilObject.points.map { scaleCoordinateByRatio($0, xRatio, yRatio) }
                pencilObject.onUpdate(adjustedCoordinates, adjustedStart, adjustedEnd)
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

    // MARK: pattarn② canvas ↔︎ NDC
    
    public func convertCoordinates_2(_ newCanvasSize: CGSize) {
        let oldCanvasSize = setting.canvasSize
        setting.canvasSize = newCanvasSize

        let applyLayer = layer
        printLayer("previousLayer. canvasSize: \(oldCanvasSize.width)x\(oldCanvasSize.height), ", layer)

        // キャンバス座標をNDCに変換
        let ndcLayer = convertCanvasToNDC(applyLayer, oldCanvasSize)

        // ログ表示のため値を追加
        self.ndcLayer = ndcLayer
        printLayer("ndcLayer. canvasSize: \(setting.canvasSize.width)x\(setting.canvasSize.height),", ndcLayer)

        // NDCを新しいキャンバス座標に変換
        let newCanvasLayer = convertNDCToCanvas(ndcLayer, newCanvasSize)
        printLayer("newCanvasLayer. canvasSize: \(setting.canvasSize.width)x\(setting.canvasSize.height),", newCanvasLayer)

        layer = newCanvasLayer
    }
    
    /// キャンバス座標をNDCに変換
    public func convertCanvasToNDC(
        _ layer: DrawingLayerData,
        _ canvasSize: CGSize
    ) -> DrawingLayerData {
        let ndcLayer = layer

        ndcLayer.objects.forEach { object in
            // 正規化した開始・終了座標
            let normalizedStart = normalizeCoordinate(object.start, canvasSize)
            let normalizedEnd = normalizeCoordinate(object.end, canvasSize)
            
            // ペンの場合、点も正規化
            if let pencilObject = object.asPencil() {
                let normalizedCoordinates = pencilObject.points.map { normalizeCoordinate($0, canvasSize) }
                pencilObject.onUpdate(normalizedCoordinates, normalizedStart, normalizedEnd)
            } else {
                object.onUpdate(normalizedStart, normalizedEnd)
            }
        }
        return ndcLayer
    }

    /// NDCをキャンバス座標に変換
    public func convertNDCToCanvas(
        _ layer: DrawingLayerData,
        _ canvasSize: CGSize
    ) -> DrawingLayerData {
        let applyLayer = layer

        applyLayer.objects.forEach { object in
            // 変換した開始・終了座標
            let unnormalizedStart = unnormalizeCoordinate(object.start, canvasSize)
            let unnormalizedEnd = unnormalizeCoordinate(object.end, canvasSize)

            // ペンの場合、点も変換
            if let pencilObject = object.asPencil() {
                let unnormalizedCoordinates = pencilObject.points.map { unnormalizeCoordinate($0, canvasSize) }
                pencilObject.onUpdate(unnormalizedCoordinates, unnormalizedStart, unnormalizedEnd)
            } else {
                object.onUpdate(unnormalizedStart, unnormalizedEnd)
            }
        }

        return applyLayer
    }

    /// キャンバスサイズに応じた座標をNDCに変換
    private func normalizeCoordinate(
        _ point: Coordinate,
        _ canvasSize: CGSize
    ) -> Coordinate {
        // キャンバスの座標を0~1の範囲に変換
        let scaledX = point.x / canvasSize.width
        let scaledY = point.y / canvasSize.height

        // NDCの座標範囲(-1~1)に変換
        let ndcX = (scaledX * 2) - 1
        let ndcY = -((scaledY * 2) - 1)

        return Coordinate(x: ndcX, y: ndcY)
    }
    
    /// NDCをキャンバスサイズに応じて座標に変換
    private func unnormalizeCoordinate(
        _ ndc: Coordinate,
        _ canvasSize: CGSize
    ) -> Coordinate {
        // NDCの範囲を0~1に逆正規化
        let unscaledX = (ndc.x + 1) / 2
        let unscaledY = (1 - ndc.y) / 2

        // 0~1の範囲をキャンバス座標にスケール
        let canvasX = unscaledX * canvasSize.width
        let canvasY = unscaledY * canvasSize.height

        return Coordinate(x: canvasX, y: canvasY)
    }
    
    
    private func printLayer(_ title: String, _ layer: DrawingLayerData) {
        layer.objects.forEach { object in
            if let object = object.asPencil(), let point = object.points.first {
                print("\(title) object: [x:\(point.x), y:\(point.y)]")
            } else {
                print("\(title) object: [x:\(object.start.x) y:\(object.end.y)]")
            }
        }
    }
}
