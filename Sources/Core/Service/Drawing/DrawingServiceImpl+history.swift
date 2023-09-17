//
//  DrawingServiceImpl+history.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/17.
//

import Foundation
import Repository

extension DrawingServiceImpl {
    public func fetchDrawingListHisory(from drawingListId: UUID) async -> Result<DrawingListHistory, Error> {
        await drawingRepository.fetchDrawingListHisory(from: drawingListId)
    }
    
    public func createDrawingListHisory(list: DrawingList) async -> Result<DrawingListHistory, Error> {
        await drawingRepository.createDrawingListHisory(list: list)
    }
    
    public func updateDrawingListHisory(list: DrawingList) async -> Result<Void, Error> {
        await drawingRepository.updateDrawingListHisory(list: list)
    }
    
    public func deleteDrawingListHisory(from drawingListId: UUID) async -> Result<Void, Error> {
        await drawingRepository.deleteDrawingListHisory(from: drawingListId)
    }
    
    public func duplicateDrawingListHistory(from drawingListId: UUID) async -> Result<DrawingListHistory, Error> {
        await drawingRepository.duplicateDrawingListHistory(from: drawingListId)
    }
    
    public func sortDrawingListHistory(from drawingListId: UUID) async -> Result<Void, Error> {
        await drawingRepository.sortDrawingListHistory(from: drawingListId)
    }
}
