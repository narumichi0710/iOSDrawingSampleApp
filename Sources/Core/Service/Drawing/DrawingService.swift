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
    func fetchDrawing(from drawingId: UUID) async -> Result<DrawingLayer, Error>
    func createDrawing(_ drawing: DrawingLayer) async -> Result<DrawingLayer, Error>
    func updateDrawing(from drawingId: UUID) async -> Result<Void, Error>
    func deleteDrawing(by drawingId: UUID) async -> Result<Void, Error>
    func duplicateDrawing(from drawingId: UUID) async -> Result<DrawingLayer, Error>

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

