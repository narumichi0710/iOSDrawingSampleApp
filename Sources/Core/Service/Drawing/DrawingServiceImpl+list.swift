//
//  DrawingServiceImpl+list.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/17.
//

import Foundation
import Repository

extension DrawingServiceImpl {
    public func fetchDrawingList(from drawingListId: UUID) async -> Result<DrawingList, Error> {
       await drawingRepository.fetchDrawingList(from: drawingListId)
    }
    
    public func createDrawingList(list: DrawingList) async -> Result<DrawingList, Error> {
        await drawingRepository.createDrawingList(list: list)
    }
    
    public func updateDrawingList(list: DrawingList) async -> Result<Void, Error> {
        await drawingRepository.updateDrawingList(list: list)
    }
    
    public func deleteDrawingList(from drawingListId: UUID) async -> Result<Void, Error> {
        await drawingRepository.deleteDrawingList(from: drawingListId)
    }
    
    public func duplicateDrawingList(from drawingListId: UUID) async -> Result<DrawingList, Error> {
        await drawingRepository.duplicateDrawingList(from: drawingListId)
    }
    
    public func sortDrawingList(from drawingListId: UUID) async -> Result<Void, Error> {
        await drawingRepository.sortDrawingList(from: drawingListId)
    }
}
