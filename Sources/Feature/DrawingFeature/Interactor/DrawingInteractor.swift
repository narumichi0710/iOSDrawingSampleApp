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
    @Published private(set) var selectedList: DrawingList?
    @Published private(set) var selectedLayer: DrawingLayer?

    public init(drawingService: DrawingService) {
        self.drawingService = drawingService
    }

    @MainActor
    func fetchDrawingList(from drawingListId: UUID) async {
        let result = await drawingService.fetchDrawingList(from: drawingListId)
    
        switch result {
        case let .success(res):
            selectedList = res
        case let .failure(e):
            print("failure fetchDrawingList \(e)")
        }
    }
    
    @MainActor
    func fetchDrawing(from drawingId: UUID) async {
        let result = await drawingService.fetchDrawing(from: drawingId)
    
        switch result {
        case let .success(res):
            selectedLayer = res
        case let .failure(e):
            print("failure selectedDrawing \(e)")
        }
    }

    
    @MainActor
    func createLayer() async {
        guard let selectedList else { return }
        let number = selectedList.layerInfos.count + 1
        let drawing = DrawingLayer.create(UUID(), "drawing_\(number)")
        let result = await drawingService.createDrawing(drawing)
        switch result {
        case let .success(res):
            selectedLayer = res
            self.selectedList!.layerInfos.append(.init(id: res.id, name: res.name))
        case let .failure(e):
            print("failure selectedDrawing \(e)")
        }
    }

}
