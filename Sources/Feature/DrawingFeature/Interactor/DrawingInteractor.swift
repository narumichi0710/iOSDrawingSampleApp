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
    
    // 画像のスケールとスクロールオフセットを考慮に入れて位置を変換
    public func transformCoordinates() {
        layer.objects.forEach { object in
            let imageSize = setting.imageSize
            let canvasSize = setting.canvasSize
            let scale = setting.scale
            let offset = setting.offset

            // キャンバス上のオブジェクトの位置を、画像の座標系に変換する関数
            func adjustCoordinate(_ coordinate: Coordinate) -> Coordinate {
                // オフセットとスケールを考慮して座標を調整
                let adjustedX = (coordinate.x - offset.x) / scale
                let adjustedY = (coordinate.y - offset.y) / scale
                return Coordinate(x: adjustedX, y: adjustedY)
            }

            // オブジェクトの開始位置と終了位置を調整
            let adjustedStart = adjustCoordinate(object.start)
            let adjustedEnd = adjustCoordinate(object.end)

            if let pencilObject = object.asPencil() {
                // ペンの場合のみ、線の座標も調整
                let adjustedPoints = pencilObject.points.map(adjustCoordinate)
                pencilObject.onUpdate(adjustedPoints, adjustedStart, adjustedEnd)
            } else {
                object.onUpdate(adjustedStart, adjustedEnd)
            }
        }
        layer.apply()
    }
}
