//
//  DrawingScroolView.swift
//
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import SwiftUI
import Service
import ViewExtension
import Repository


public struct DrawingScroolView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var interactor: DrawingInteractor
    
    @State private var isShowCoordinate = false
    @State private var currentCoordinate = ""
    
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
        .onAppear {
            interactor.setting.canvasSize = .init(width: 350, height: 350)
        }
    }
    
    private func header() -> some View {
        VStack {
            HStack {
                Text("Image:")
                Menu("\(Int(interactor.setting.imageSize.width)) x \(Int(interactor.setting.imageSize.height))") {
                    Button("100x100") {
                        interactor.setting.imageSize = .init(width: 100, height: 100)
                    }
                    Button("225x225") {
                        interactor.setting.imageSize = .init(width: 225, height: 225)
                    }
                    Button("350x350") {
                        interactor.setting.imageSize = .init(width: 350, height: 350)
                    }
                }
                Text("Canvas:")
                Menu("\(Int(interactor.setting.canvasSize.width)) x \(Int(interactor.setting.canvasSize.height))") {
                    Button("100x100") {
                        interactor.setting.canvasSize = .init(width: 100, height: 100)
                    }
                    Button("225x225") {
                        interactor.setting.canvasSize = .init(width: 225, height: 225)
                    }
                    Button("350x350") {
                        interactor.setting.canvasSize = .init(width: 350, height: 350)
                    }
                }
                Spacer()

            }
            HStack {
                Text("Scale: \(interactor.setting.scale) offset x: \(Int(interactor.setting.offset.x)), y: \(Int(interactor.setting.offset.y))")
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
        .padding()
    }
    
    private func content() -> some View {
        ZStack {
            GeometryReader { geo in
                if let url = URL(string: interactor.file.imageUrl) {
                    DrawingScrollView(
                        imageUrl: url,
                        onLoadedImage: { size in
                            interactor.setting.imageSize = size
                        },
                        onUpdatedOffset: { scale, offset in
                            interactor.setting.scale = scale
                            interactor.setting.offset = offset
                        }
                    ) {
                        DrawingScroolCanvas(
                            geo: geo,
                            setting: $interactor.setting,
                            layer: interactor.layer,
                            isShowCoordinate: $isShowCoordinate,
                            currentCoordinate: $currentCoordinate
                        )
                    }
                }
            }
        }
        .frame(width: interactor.setting.canvasSize.width, height: interactor.setting.canvasSize.height)
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

public struct DrawingScrollView<Content: View>: View {
    private let imageUrl: URL
    private let onLoadedImage: (CGSize) -> Void
    private let onUpdatedOffset: (CGFloat, CGPoint) -> Void
    private let content: Content

    public init(
        imageUrl: URL,
        onLoadedImage: @escaping (CGSize) -> Void,
        onUpdatedOffset: @escaping (CGFloat, CGPoint) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.imageUrl = imageUrl
        self.onLoadedImage = onLoadedImage
        self.onUpdatedOffset = onUpdatedOffset
        self.content = content()
    }
    
    public var body: some View {
        ScrollContent(
            imageUrl: imageUrl,
            onLoadedImage: onLoadedImage,
            onUpdatedOffset: onUpdatedOffset,
            content: content
        )
    }
}

struct ScrollContent<Content: View>: UIViewRepresentable {
    private let imageUrl: URL
    private let onLoadedImage: (CGSize) -> Void
    private let onUpdatedOffset: (CGFloat, CGPoint) -> Void
    private let content: Content

    public init(
        imageUrl: URL,
        onLoadedImage: @escaping (CGSize) -> Void,
        onUpdatedOffset: @escaping (CGFloat, CGPoint) -> Void,
        content: Content
    ) {
        self.imageUrl = imageUrl
        self.onLoadedImage = onLoadedImage
        self.onUpdatedOffset = onUpdatedOffset
        self.content = content
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.bouncesZoom = false

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = UIColor.clear

        scrollView.addSubview(imageView)
        scrollView.addSubview(hostingController.view)
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                    imageView.frame = CGRect(origin: .zero, size: image.size)
                    scrollView.contentSize = image.size
                    hostingController.view.frame = CGRect(origin: .zero, size: image.size)
                    configureInitialZoomScale(for: imageView, in: scrollView)
                }
            }
        }.resume()
        
        return scrollView
    }

    private func configureInitialZoomScale(for imageView: UIImageView, in scrollView: UIScrollView) {
        guard let image = imageView.image else { return }
        let widthScale = scrollView.bounds.size.width / image.size.width
        let heightScale = scrollView.bounds.size.height / image.size.height
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = minScale
        
        onLoadedImage(image.size)
        onUpdatedOffset(scrollView.zoomScale, scrollView.contentOffset)
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollContent

        init(_ parent: ScrollContent) {
            self.parent = parent
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onUpdatedOffset(scrollView.zoomScale, scrollView.contentOffset)
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return scrollView.subviews.first(where: { $0 is UIImageView })
        }
    }
}
