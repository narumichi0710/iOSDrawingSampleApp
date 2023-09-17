//
//  DrawingService.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import Foundation
import Repository

public protocol DrawingService {
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

public final class DrawingServiceImpl: DrawingService {
    let drawingRepository: DrawingRepository
    
    public init(
        drawingRepository: DrawingRepository
    ) {
        self.drawingRepository = drawingRepository
    }
}


public final class DrawingServiceStub: DrawingService {
    let drawingRepository: DrawingRepository = DrawingRepositoryStub()

    public init() {}

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
    
    public func fetchDrawing(from drawingId: UUID) async -> Result<Drawing, Error> {
        await drawingRepository.fetchDrawing(from: drawingId)
    }
    
    public func createDrawing(_ drawing: Drawing) async -> Result<Drawing, Error> {
        await drawingRepository.createDrawing(drawing)
    }
    
    public func updateDrawing(from drawingId: UUID) async -> Result<Void, Error> {
        await drawingRepository.updateDrawing(from: drawingId)
    }
    
    public func deleteDrawing(by drawingId: UUID) async -> Result<Void, Error> {
        await drawingRepository.deleteDrawing(by: drawingId)
    }
    
    public func duplicateDrawing(from drawingId: UUID) async -> Result<Drawing, Error> {
        await drawingRepository.duplicateDrawing(from: drawingId)
    }
    
    
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

