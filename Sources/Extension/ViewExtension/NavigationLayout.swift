//
//  NavigationLayout.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/17.
//

import SwiftUI

public struct NavigationLayout<Content: View>: View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content
            }
        } else {
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
}
