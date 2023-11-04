//
//  RootView.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/10.
//

import SwiftUI
import Service
import DrawingFeature
import ViewExtension
import Repository // File関連実装後削除

public struct RootView: View {
    private let factory: ServiceFactory
    
    public init(factory: ServiceFactory) {
        self.factory = factory
    }

    public var body: some View {
        NavigationLayout {
            List {
                ForEach(mockFiles, id: \.id) {
                    NavigationLink(
                        $0.name,
                        destination: DrawingRootView(drawingService: factory.drawingService, file: $0)
                    )
                }
            }
            .navigationTitle("drawing sample app")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
