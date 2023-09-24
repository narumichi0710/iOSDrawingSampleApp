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
    
    // TODO: あとで差し替え
    private var file: File
    @State var points = [CGPoint]()

    public init (
        file: File,
        drawingService: DrawingService
    ) {
        self.file = file
        _interactor = .init(wrappedValue: .init(drawingService: drawingService))
    }
    
    public var body: some View {
        VStack {
            header()
            Spacer(minLength: 0)
            content()
            Spacer(minLength: 0)
            footer()
        }
        .navigationToolbar(file.name, dismiss: { dismiss() })
        .task { await interactor.fetchDrawingList(from: file.id) }
    }

    private func header() -> some View {
        Group {
            if let selectedList = interactor.selectedList {
                VStack {
                    Divider()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(selectedList.layerInfos, id: \.id) { info in
                                Button {
                                    Task {
                                        await interactor.fetchDrawing(from: info.id)
                                    }
                                } label: {
                                    let isSelected = interactor.selectedLayer?.id == info.id
                                    Text(info.name)
                                        .foregroundColor(isSelected ? Color.black : Color.gray)
                                }
                            }
                        }
                        .padding(8)
                    }
                    Divider()
                }
                .frame(maxWidth: .infinity)
                .onAppear {
                    guard let info = selectedList.layerInfos.first else { return }
                    Task { await interactor.fetchDrawing(from: info.id) }
                }
            }
        }
    }
    
    private func content() -> some View {
        ZStack {
            // 画像の表示
            if let imageURL = URL(string: file.imageUrl) {
                AsyncImage(url: imageURL) {
                    $0
                } placeholder: {
                    ProgressView()
                }

            }
            if let selectedLayer = interactor.selectedLayer {
                PaintCanvas(
                    layer: selectedLayer,
                    interactor: interactor
                )
            }
        }
    }
    
    private func footer() -> some View {
        Button("新しいキャンバスを追加") {
            Task {
               await interactor.createLayer()
            }
        }
        .padding(8)
    }
}
