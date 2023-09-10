//
//  SwiftUIApp.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/10.
//

import Service
import SwiftUI

public struct SwiftUIApp: App {

    public init() {}

    public var body: some Scene {
        WindowGroup {
            RootView(factory: ServiceFactoryImpl())
        }
    }
}
