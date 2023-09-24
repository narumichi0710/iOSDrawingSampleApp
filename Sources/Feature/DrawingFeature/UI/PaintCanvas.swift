//
//  PaintCanvas.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/17.
//

import SwiftUI
import Service
import ViewExtension
import Repository // File関連実装後削除

public struct PaintCanvas: View {
    @ObservedObject private var interactor: DrawingInteractor
    private let layer: DrawingLayer

    @State private var editingLayer: DrawingLayer
    @State private var points: [CGPoint] = []

    
    public init (
        layer: DrawingLayer,
        interactor: DrawingInteractor
    ) {
        self.layer = layer
        self.interactor = interactor
        _editingLayer = .init(wrappedValue: layer)
    }
    
    public var body: some View {
        content()
    }
    
    private func content() -> some View {
        ZStack {
            // 保存済みのレイヤー
            ForEach(layer.objects, id: \.id) {
                PaintObject(object: $0)
            }
            // 編集中のレイヤー
            ForEach(editingLayer.objects, id: \.id) {
                PaintObject(object: $0)
            }
                        
            // 編集中のオブジェクト
            if !points.isEmpty {
               Path { path in
                   path.move(to: points.first!)
                   for point in points.dropFirst() {
                       path.addLine(to: point)
                   }
               }
               .stroke(Color.red, lineWidth: 2)
           }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    self.points.append(value.location)
                }
                .onEnded { value in
                    let newObject = DrawingObject(
                        id: UUID(),
                        type: 0,
                        start: self.points.first!,
                        end: value.location,
                        lineWidth: 2
                    )
                    self.editingLayer.objects.append(newObject)
//                    self.interactor.save(layer: self.editingLayer)
                    self.points = []
                }
        )
    }
}
