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
}
