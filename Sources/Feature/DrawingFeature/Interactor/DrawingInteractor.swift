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

        // キャンバス座標をNDCに変換
        let ndcLayer = convertCanvasToNDC(layer, oldCanvasSize)
        // NDCを新しいキャンバス座標に変換
        let newCanvasLayer = convertNDCToCanvas(ndcLayer, newCanvasSize)
        
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
        // キャンバス上の座標を0.0~1.0の範囲に正規化
        let normalizedX = point.x / canvasSize.width
        let normalizedY = point.y / canvasSize.height

        // 正規化された座標をNDC(-1.0~1.0)の範囲に変換
        return Coordinate(
            x: normalizedX * 2 - 1,
            y: 1 - normalizedY * 2
        )
    }
    
    /// NDCをキャンバスサイズに応じて座標に変換
    private func unnormalizeCoordinate(
        _ ndc: Coordinate,
        _ canvasSize: CGSize
    ) -> Coordinate {
        // NDCの範囲を0.0~1.0に逆正規化
        let unNormalizedX = (ndc.x + 1) / 2
        let unNormalizedY = (1 - ndc.y) / 2

        // 逆正規化された座標をキャンバスサイズにスケール
        return Coordinate(
            x: unNormalizedX * canvasSize.width,
            y: unNormalizedY * canvasSize.height
        )
    }
}
