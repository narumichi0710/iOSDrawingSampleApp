//
//  JsonView.swift
//
//
//  Created by Narumichi Kubo on 2023/11/07.
//

import Foundation
import SwiftUI

public struct JsonView: View {
    private let layer: DrawingLayerData

    private var jsonData: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(layer.toEntity())
    }

    private var jsonString: String? {
        jsonData.flatMap { String(data: $0, encoding: .utf8) }
    }
    
    public init(layer: DrawingLayerData) {
        self.layer = layer
    }
    
    public var body: some View {
        ScrollView {
            if let jsonData, let jsonString = jsonString {
                VStack {
                    Text("\(jsonData.count) bytes")
                        .padding()
                    Text(jsonString)
                        .textSelection(.enabled)
                        .font(.body)
                        .padding()
                        .border(Color.gray, width: 1)
                }
            } else {
                Text("JSONの変換に失敗しました。")
                    .foregroundColor(.red)
            }
        }
    }
}
