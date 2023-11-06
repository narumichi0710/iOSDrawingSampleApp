//
//  DrawingRootView.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import SwiftUI
import Service
import ViewExtension
import Repository

public struct DrawingRootView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var interactor: DrawingInteractor
    
    private var selectedType: DrawingObjectType { interactor.setting.type }
    private var selectedColor: DrawingObjectColor { interactor.setting.color }
    
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
        .overlay { DrawingCanvas(setting: $interactor.setting, layer: interactor.layer) }
    }

    private func footer() -> some View {
        VStack(spacing: 16.0) {
            // 色選択
            HStack(spacing: 16.0) {
                ForEach(DrawingObjectColor.allCases, id: \.self) { color in
                    Button {
                        interactor.changeDrawingColor(color)
                    } label: {
                        Circle()
                            .fill(color.toUIColor)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
                            )
                            .shadow(radius: selectedColor == color ? 5 : 0)
                            .scaleEffect(selectedColor == color ? 1.2 : 1)
                            .animation(.easeInOut, value: selectedColor == color)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
    
            // 描画種別選択
            HStack(spacing: 8.0) {
                ForEach(DrawingObjectType.allCases, id: \.self) { type in
                    Button {
                        interactor.changeDrawingType(type)
                    } label: {
                        Image(systemName: type.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(selectedType == type ? .white : .gray)
                            .padding()
                            .background(selectedType == type ? Color.blue : Color.clear)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedType == type ? Color.blue : Color.gray, lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(selectedType == type ? 1.1 : 1)
                    .animation(.easeInOut, value: selectedType == type)
                }
            }
        }
        .padding()
    }
}
