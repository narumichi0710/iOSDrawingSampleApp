//
//  DrawingSettingData.swift
//
//
//  Created by Narumichi Kubo on 2023/11/05.
//

import Foundation
import Repository

/// オブジェクト作成前に必要なデータ
public struct DrawingSettingData {
    var type = DrawingObjectType.pencil
    var color = DrawingObjectColor.blue
    var lineWidth = 5.0
    var text = ""
    var tmpCoordinate = Coordinate()

    public init() {}
}
