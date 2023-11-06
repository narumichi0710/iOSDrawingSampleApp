//
//  DrawingResizedImageView.swift
//
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import SwiftUI
import Service
import ViewExtension
import Repository

public struct DrawingResizedImageView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var interactor: DrawingInteractor
    
    @State private var isShowCoordinate = false
    @State private var currentCoordinate = ""
    
    @State private var originalImage: UIImage?
    private var originalImageMaxX: CGFloat? { originalImage?.size.width }
    private var originalImageMaxY: CGFloat? { originalImage?.size.height }
    
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
            header()
            Spacer(minLength: 0)
            content()
                .padding(.horizontal, isShowCoordinate ? 32 : 0)
            Spacer(minLength: 0)
            footer()
        }
        .navigationToolbar(
            title: interactor.file.name,
            dismiss: { dismiss() },
            trailingButton: Button(
                action: {
                    interactor.layer.reset()
                    currentCoordinate = ""
                },
                label: { Text("Reset") }
            )
        )
    }
    
    private func header() -> some View {
        VStack {
            if let originalImageMaxX, let originalImageMaxY {
                HStack {
                    Text("Original Image Size: \(Int(originalImageMaxX)) x \(Int(originalImageMaxY))")
                    Spacer()
                }
                HStack {
                    Text("Canvas Size: 300 x 300")
                    Spacer()
                }
                HStack {
                    Text("Current Canvas Coordinate")
                    Spacer()
                    Text(currentCoordinate)
                }
                VStack {
                    HStack {
                        Text("Transform to Image Coordinate")
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("Transform")
                        }
                    }
                }
                Toggle(isOn: $isShowCoordinate) {
                    Text("Visible Canvas Coordinate Grid")
                }
            }
        }
        .padding()
    }
    
    private func content() -> some View {
        ZStack {
            GeometryReader { geometryProxy in
                AsyncImage(
                    url: URL(string: interactor.file.imageUrl),
                    content: { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .onAppear {
                                originalImage = image.asUIImage()
                            }
                    },
                    placeholder: { ProgressView() }
                )
                .overlay {
                    DrawingCanvas(
                        geometryProxy: geometryProxy,
                        setting: $interactor.setting,
                        layer: interactor.layer,
                        isShowCoordinate: $isShowCoordinate,
                        currentCoordinate: $currentCoordinate
                    )
                }
            }
        }
        .frame(width: 300, height: 300)
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

extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        controller.view.layoutIfNeeded()
        let size = controller.sizeThatFits(in: CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let view = controller.view
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
