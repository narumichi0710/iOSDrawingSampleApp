//
//  DrawingReplayView.swift
//
//
//  Created by Narumichi Kubo on 2023/11/07.
//

import SwiftUI
import Service
import ViewExtension
import Repository

public struct DrawingReplayView: View {
    @ObservedObject private var layer: DrawingLayerData

    public init(
        layer: DrawingLayerData
    ) {
        self.layer = layer
    }
    
    public var body: some View {
        ZStack {
            // 編集済のオブジェクト
            ForEach(layer.objects, id: \.id) {
                RemoteDrawingObject(object: $0)
            }
        }
    }
}
