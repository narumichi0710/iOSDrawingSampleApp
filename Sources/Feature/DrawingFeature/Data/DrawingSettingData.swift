//
//  DrawingSettingData.swift
//
//
//  Created by Narumichi Kubo on 2023/11/05.
//

import Foundation
import Repository

public struct DrawingSettingData {
    var type = DrawingObjectType.pencil
    var color = DrawingObjectColor.blue
    var lineWidth = 5.0
    
    public init() {}
}
