//
//  View+NavigationBar.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/17.
//

import Foundation
import SwiftUI

struct HideToolbar: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .navigationTitle("")
                .toolbarBackground(.hidden, for: .navigationBar)
                .navigationBarBackButtonHidden(true)
        } else {
            content
                .navigationTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

public extension View {
    func hideNavigationToolbar() -> some View {
        modifier(HideToolbar())
    }
}

struct ToolBar<TrailingButton: View>: ViewModifier {
    let title: String
    let dismiss: () -> Void
    var trailingButton: TrailingButton

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingButton
                }
            }
    }

    private func backButton() -> some View {
        HStack {
            Button(
                action: { dismiss() },
                label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color.black)
                }
            )
        }
    }
}

public extension View {
    func navigationToolbar(
        _ title: String?,
        dismiss: @escaping () -> Void
    ) -> some View {
        modifier(
            ToolBar(
                title: title ?? "",
                dismiss: dismiss,
                trailingButton: EmptyView()
            )
        )
    }

    func navigationToolbar(
        title: String?,
        dismiss: @escaping () -> Void,
        trailingButton: some View
    ) -> some View {
        modifier(
            ToolBar(
                title: title ?? "",
                dismiss: dismiss,
                trailingButton: trailingButton
            )
        )
    }
}
