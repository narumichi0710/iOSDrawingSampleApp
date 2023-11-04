//
//  Color+hex.swift
//
//
//  Created by Narumichi Kubo on 2023/11/04.
//

import Foundation
import SwiftUI

public extension Color {
    init(hex: String) {
        let hexValue = Int(hex, radix: 16) ?? 0
        let red = Double((hexValue >> 16) & 0xFF) / 255.0
        let green = Double((hexValue >> 8) & 0xFF) / 255.0
        let blue = Double(hexValue & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
