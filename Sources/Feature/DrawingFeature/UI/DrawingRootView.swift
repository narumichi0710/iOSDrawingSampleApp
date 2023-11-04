//
//  DrawingRootView.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import SwiftUI
import Service
import ViewExtension
import Repository // File関連実装後削除

public struct DrawingRootView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var interactor: DrawingInteractor
    
    public init (
        drawingService: DrawingService,
        file: File
    ) {
        _interactor = .init(wrappedValue: .init(drawingService: drawingService, file: file))
    }
    
    public var body: some View {
        VStack {
            Spacer(minLength: 0)
            content()
            Spacer(minLength: 0)
            footer()
        }
        .navigationToolbar(
            title: interactor.file.name,
            dismiss: { dismiss() },
            trailingButton: Button(
                action: { interactor.layer.reset() },
                label: { Text("Reset") }
            )
        )
    }
    
    private func content() -> some View {
        AsyncImage(
            url: URL(string: interactor.file.imageUrl),
            content: { $0 },
            placeholder: { ProgressView() }
        )
        .overlay { DrawingCanvas(layer: interactor.layer) }
    }

    private func footer() -> some View {
        HStack {
            // 色設定
        }
    }
}
