//
//  DrawingObjectState.swift
//
//
//  Created by Narumichi Kubo on 2023/11/04.
//

import Foundation

public enum DrawingObjectState: String, Codable {
    /// 新規作成
    case created
    /// 更新
    case updated
    /// 削除
    case deleted
    /// 同期
    case synced

    public var isSendable: Bool {
        self != .synced
    }
}
