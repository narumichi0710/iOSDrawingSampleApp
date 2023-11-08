//
//  TextInputView.swift
//
//
//  Created by Narumichi Kubo on 2023/11/06.
//

import SwiftUI
import Service
import Repository
import ViewExtension
import UIKit


public struct TextInputView: View {
    private let textColor: Color
    private let backgroundColor: Color
    private var onFinished: ([Coordinate.Info]) -> Void
    @State private var text = ""
    @State private var inputHistory = [Coordinate.Info]()
    @State private var editorSize: CGSize = .init(width: 20, height: 20)
    @FocusState private var isFocused: Bool

    @State private var previousInputTime: TimeInterval = .zero

    public init(
        textColor: DrawingObjectColor,
        backgroundColor: DrawingObjectColor,
        onFinished: @escaping ([Coordinate.Info]) -> Void
    ) {
        self.textColor = textColor.toUIColor
        self.backgroundColor = backgroundColor.toUIColor
        self.onFinished = onFinished
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.75)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Spacer()
                        Button("Finish") {
                            onFinished(inputHistory)
                        }
                        .padding()
                    }
                    Spacer()

                    CenteredTextEditor(
                        text: $text,
                        textColor: textColor,
                        onFinished: { onFinished(inputHistory) }
                    )
                    .focused($isFocused)
                    .frame(width: editorSize.width, height: editorSize.height)
                    .onChange(of: text) {
                        if $0.contains("\n") {
                            text = $0.replacingOccurrences(of: "\n", with: "")
                        }
                        let textView = UITextView()
                        textView.text = text
                        textView.font = UIFont.systemFont(ofSize: 20)
                        editorSize = textView.sizeThatFits(geometry.size)

                        let currentTime = Date().timeIntervalSince1970
                        let interval = previousInputTime == .zero ? 0.0 : currentTime - previousInputTime
                        let info = Coordinate.Info(interval: interval, text: $0)
                        inputHistory.append(info)
                        previousInputTime = currentTime
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(text.isEmpty ? Color.clear : backgroundColor)
                    )
                    .onAppear {
                        isFocused = true
                    }
                    Spacer()
                }
            }
        }
    }
}


public struct CenteredTextEditor: UIViewRepresentable {
    @Binding private var text: String
    private let textColor: Color
    private let onFinished: () -> Void
    
    public init(
        text: Binding<String>,
        textColor: Color,
        onFinished: @escaping () -> Void = {}
    ) {
        _text = text
        self.textColor = textColor
        self.onFinished = onFinished
    }
    
    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.returnKeyType = .done
        textView.textColor = UIColor(textColor)
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.delegate = context.coordinator
        return textView
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.textColor = UIColor(textColor)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, UITextViewDelegate {
        private var parent: CenteredTextEditor

        public init(_ parent: CenteredTextEditor) {
            self.parent = parent
        }

        public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        public func textView(
            _ textView: UITextView,
            shouldChangeTextIn range: NSRange,
            replacementText text: String
        ) -> Bool {
           if text == "\n" {
               textView.resignFirstResponder()
               parent.onFinished()
               return false
           }
           return true
       }
    }
}
