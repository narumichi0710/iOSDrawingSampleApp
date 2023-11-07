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
    private var onFinish: (String) -> Void
    @State private var text = ""
    @State private var editorSize: CGSize = .init(width: 20, height: 20)
    @FocusState private var isFocused: Bool
    
    public init(
        textColor: DrawingObjectColor,
        backgroundColor: DrawingObjectColor,
        onFinish: @escaping (String) -> Void
    ) {
        self.textColor = textColor.toUIColor
        self.backgroundColor = backgroundColor.toUIColor
        self.onFinish = onFinish
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
                            onFinish(text)
                        }
                        .padding()
                    }
                    Spacer()

                    CenteredTextEditor(
                        text: $text,
                        textColor: textColor,
                        onFinish: { onFinish(text) }
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
    private let onFinish: () -> Void
    
    public init(
        text: Binding<String>,
        textColor: Color,
        onFinish: @escaping () -> Void = {}
    ) {
        _text = text
        self.textColor = textColor
        self.onFinish = onFinish
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
               parent.onFinish()
               return false
           }
           return true
       }
    }
}
