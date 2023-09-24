//
//  DrawingServiceImpl+drawing.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/17.
//

import Foundation
import Repository

extension DrawingServiceImpl {
    public func fetchDrawing(from drawingId: UUID) async -> Result<DrawingLayer, Error> {
        await drawingRepository.fetchDrawing(from: drawingId)
    }
    
    public func createDrawing(_ drawing: DrawingLayer) async -> Result<DrawingLayer, Error> {
        await drawingRepository.createDrawing(drawing)
    }
    
    public func updateDrawing(from drawingId: UUID) async -> Result<Void, Error> {
        await drawingRepository.updateDrawing(from: drawingId)
    }
    
    public func deleteDrawing(by drawingId: UUID) async -> Result<Void, Error> {
        await drawingRepository.deleteDrawing(by: drawingId)
    }
    
    public func duplicateDrawing(from drawingId: UUID) async -> Result<DrawingLayer, Error> {
        await drawingRepository.duplicateDrawing(from: drawingId)
    }
}
