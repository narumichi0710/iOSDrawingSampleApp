//
//  DrawingRepository.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import Foundation

public protocol DrawingRepository {
    
    /// 描画データ配列のCRUD関連操作
    func fetchDrawingList(from drawingListId: UUID) async -> Result<DrawingList, Error>
    func createDrawingList(list: DrawingList) async -> Result<DrawingList, Error>
    func updateDrawingList(list: DrawingList) async -> Result<Void, Error>
    func deleteDrawingList(from drawingListId: UUID) async -> Result<Void, Error>
    func duplicateDrawingList(from drawingListId: UUID) async -> Result<DrawingList, Error>
    func sortDrawingList(from drawingListId: UUID) async -> Result<Void, Error>
    
    /// 描画データのCRUD関連操作
    func fetchDrawing(from drawingId: UUID) async -> Result<Drawing, Error>
    func createDrawing(_ drawing: Drawing) async -> Result<Drawing, Error>
    func updateDrawing(from drawingId: UUID) async -> Result<Void, Error>
    func deleteDrawing(by drawingId: UUID) async -> Result<Void, Error>
    func duplicateDrawing(from drawingId: UUID) async -> Result<Drawing, Error>

    /// 履歴
    func fetchDrawingListHisory(from drawingListId: UUID) async -> Result<DrawingListHistory, Error>
    func createDrawingListHisory(list: DrawingList) async -> Result<DrawingListHistory, Error>
    func updateDrawingListHisory(list: DrawingList) async -> Result<Void, Error>
    func deleteDrawingListHisory(from drawingListId: UUID) async -> Result<Void, Error>
    func duplicateDrawingListHistory(from drawingListId: UUID) async -> Result<DrawingListHistory, Error>
    func sortDrawingListHistory(from drawingListId: UUID) async -> Result<Void, Error>
}

public final class DrawingRepositoryStub: DrawingRepository {
    public func fetchDrawingList(from drawingListId: UUID) async -> Result<DrawingList, Error> {
        .success(.mockDrawingList)
    }
    
    public func createDrawingList(list: DrawingList) async -> Result<DrawingList, Error> {
        .success(.mockDrawingList)
    }
    
    public func updateDrawingList(list: DrawingList) async -> Result<Void, Error> {
        .success(())
    }
    
    public func deleteDrawingList(from drawingListId: UUID) async -> Result<Void, Error> {
        .success(())
    }
    
    public func duplicateDrawingList(from drawingListId: UUID) async -> Result<DrawingList, Error> {
        .success(.mockDrawingList)
    }
    
    public func sortDrawingList(from drawingListId: UUID) async -> Result<Void, Error> {
        .success(())
    }
    
    public func fetchDrawing(from drawingId: UUID) async -> Result<Drawing, Error> {
        .success(.mockDrawing)
    }
    
    public func createDrawing(_ drawing: Drawing) async -> Result<Drawing, Error> {
        .success(.mockDrawing)
    }
    
    public func updateDrawing(from drawingId: UUID) async -> Result<Void, Error> {
        .success(())
    }
    
    public func deleteDrawing(by drawingId: UUID) async -> Result<Void, Error> {
        .success(())
    }
    
    public func duplicateDrawing(from drawingId: UUID) async -> Result<Drawing, Error> {
        .success(.mockDrawing)
    }
    
    
    public func fetchDrawingListHisory(from drawingListId: UUID) async -> Result<DrawingListHistory, Error> {
        .success(.mockDrawingListHistory)
    }
    
    public func createDrawingListHisory(list: DrawingList) async -> Result<DrawingListHistory, Error> {
        .success(.mockDrawingListHistory)
    }
    
    public func updateDrawingListHisory(list: DrawingList) async -> Result<Void, Error> {
        .success(())
    }
    
    public func deleteDrawingListHisory(from drawingListId: UUID) async -> Result<Void, Error> {
        .success(())
    }
    
    public func duplicateDrawingListHistory(from drawingListId: UUID) async -> Result<DrawingListHistory, Error> {
        .success(.mockDrawingListHistory)
    }
    
    public func sortDrawingListHistory(from drawingListId: UUID) async -> Result<Void, Error> {
        .success(())
    }

    public init() {}
}
