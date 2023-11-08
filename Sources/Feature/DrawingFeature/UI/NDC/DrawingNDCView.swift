//
//  DrawingNDCView.swift
//
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import SwiftUI
import Service
import ViewExtension
import Repository

public struct DrawingNDCView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var interactor: DrawingInteractor
    
    @State private var isPresentedJsonView1 = false
    @State private var isPresentedJsonView2 = false

    @State private var isShowCoordinate = false
    @State private var currentCoordinate = ""
    @State private var isPresentedReplay = false

    
    private var selectedType: DrawingObjectType { interactor.setting.type }
    private var selectedColor: DrawingObjectColor { interactor.setting.color }
        
    public init (
        drawingService: DrawingService,
        file: File
    ) {
        let interactor = DrawingInteractor(drawingService: drawingService, file: file)
        interactor.setting.canvasSize = .init(width: 300.0, height: 300.0)
        _interactor = .init(wrappedValue: interactor)
    }
    
    public init(interactor: DrawingInteractor) {
        _interactor = .init(wrappedValue: interactor)
    }
    
    public var body: some View {
        ZStack {
            VStack {
                header()
                Spacer(minLength: 0)
                content()
                Spacer(minLength: 0)
                footer()
            }
            
            NavigationLink(
                "",
                isActive: $isPresentedJsonView1,
                destination: {
                    JsonView(layer: interactor.layer)
                }
            )
            
            NavigationLink(
                "",
                isActive: $isPresentedJsonView2,
                destination: {
                    JsonView(layer: interactor.ndcLayer)
                }
            )
            NavigationLink(
                "",
                isActive: $isPresentedReplay,
                destination: {
                    replayContent()
                }
            )
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
            HStack {
                Text("Image: \(Int(interactor.setting.imageSize.width))x\(Int(interactor.setting.imageSize.height))")
                Text("Canvas:")
                Menu("\(Int(interactor.setting.canvasSize.width)) x \(Int(interactor.setting.canvasSize.height))") {
                    Button("100x100") {
                        interactor.convertCoordinates_2(.init(width: 100, height: 100))
                    }
                    Button("225x225") {
                        interactor.convertCoordinates_2(.init(width: 225, height: 225))
                    }
                    Button("300x300") {
                        interactor.convertCoordinates_2(.init(width: 300, height: 300))
                    }
                }
                Spacer()
                
            }
            
            HStack {
                Text("Current Canvas Coordinate")
                Spacer()
                Text(currentCoordinate)
            }
            HStack {
                Text("Check Json Data")
                Button {
                    isPresentedJsonView1 = true
                } label: {
                    Text("Click")
                }
                Spacer()
            }
            HStack {
                Text("Check NDC Json Data")
                Button {
                    isPresentedJsonView2 = true
                } label: {
                    Text("Click")
                }
                Spacer()
            }
            HStack {
                Text("Replay Drawing")
                Button {
                    interactor.setting.imageSize = .zero
                    isPresentedReplay = true
                } label: {
                    Text("Click")
                }
                Spacer()
            }
            
            Toggle(isOn: $isShowCoordinate) {
                Text("Visible Canvas Coordinate Grid")
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
                                if let image = image.asUIImage() {
                                    interactor.setting.imageSize = image.size
                                }
                            }
                    },
                    placeholder: { ProgressView() }
                )
                .overlay {
                    if interactor.setting.imageSize != .zero {
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
        }
        .frame(
            width: interactor.setting.canvasSize.width,
            height:  interactor.setting.canvasSize.height
        )
    }

    private func replayContent() -> some View {
        ZStack {
            GeometryReader { geometryProxy in
                AsyncImage(
                    url: URL(string: interactor.file.imageUrl),
                    content: { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .onAppear {
                                if let image = image.asUIImage() {
                                    interactor.setting.imageSize = image.size
                                }
                            }
                    },
                    placeholder: { ProgressView() }
                )
                .overlay {
                    if interactor.setting.imageSize != .zero {
                        DrawingReplayView(layer: interactor.layer)
                    }
                }
            }
        }
        .frame(
            width: interactor.setting.canvasSize.width,
            height:  interactor.setting.canvasSize.height
        )
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
