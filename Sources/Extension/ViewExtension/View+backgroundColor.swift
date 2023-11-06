//
//  View+background.swift
//
//
//  Created by Narumichi Kubo on 2023/11/06.
//

import SwiftUI
import UIKit

public extension View {
    func setBackgroundClear() -> some View {
        background(BackgroundClearView())
    }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        Task {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}
