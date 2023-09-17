//
//  DrawingInteractor.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import Foundation
import SwiftUI
import Service
import Repository // for DrawingList

public class DrawingInteractor: ObservableObject {
    let drawingService: DrawingService
    @Published private(set) var selectedDrawingList: DrawingList?
    @Published private(set) var selectedDrawing: Drawing?

    @MainActor
    func fetchDrawingList(from drawingListId: UUID) async {
        let result = await drawingService.fetchDrawingList(from: drawingListId)
    
        switch result {
        case let .success(res):
            selectedDrawingList = res
        case let .failure(e):
            print("failure fetchDrawingList \(e)")
        }
    }
    
    @MainActor
    func fetchDrawing(from drawingId: UUID) async {
        let result = await drawingService.fetchDrawing(from: drawingId)
    
        switch result {
        case let .success(res):
            selectedDrawing = res
        case let .failure(e):
            print("failure selectedDrawing \(e)")
        }
    }

    public init(drawingService: DrawingService) {
        self.drawingService = drawingService
    }
}
