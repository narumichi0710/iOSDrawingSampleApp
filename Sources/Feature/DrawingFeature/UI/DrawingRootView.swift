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
            if let selectedDrawingList = interactor.selectedDrawingList {
                VStack {
                    Divider()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(selectedDrawingList.drawingInfos, id: \.id) { info in
                                Button {
                                    Task {
                                        await interactor.fetchDrawing(from: info.id)
                                    }
                                } label: {
                                    Text(info.name)
                                }
                            }
                        }
                        .padding(8)
                    }
                    Divider()
                }
                .frame(maxWidth: .infinity)
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
    
            if let selectedDrawing = interactor.selectedDrawing {
                ZStack {
                    // お絵描きの線を表示
                    Path { path in
                        path.move(to: points.first ?? CGPoint.zero)
                        for point in points {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(Color.red, lineWidth: 2)
                }
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            points.append(value.location)
                        })
                        .onEnded({ value in
                            // お絵描きデータの保存など
                        })
                )
            }
        }
    }
    
    private func footer() -> some View {
        EmptyView()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingRootView(
            file: mockFiles.first!,
            drawingService: ServiceFactoryStub().drawingService
        )
    }
}
