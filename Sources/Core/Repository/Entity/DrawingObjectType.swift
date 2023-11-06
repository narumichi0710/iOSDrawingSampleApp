//
//  DrawingObjectType.swift
//
//
//  Created by Narumichi Kubo on 2023/11/04.
//

import Foundation

public enum DrawingObjectType: String, Codable, CaseIterable {
    /// ペン
    case pencil
    /// 矢印線
    case arrowLine
    /// 四角形
    case rectangle
    /// 円
    case circle
    /// テキスト
    case text

    public var iconName: String {
        switch self {
        case .pencil:
            return "pencil"
        case .arrowLine:
            return "arrow.down.left"
        case .rectangle:
            return "rectangle"
        case .circle:
            return "circle"
        case .text:
            return "textformat"
        }
    }
}
