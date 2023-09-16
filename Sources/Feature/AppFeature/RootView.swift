//
//  RootView.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/10.
//

import SwiftUI
import Service
import DrawingFeature

public struct RootView: View {
    private let factory: ServiceFactory
    
    public init(factory: ServiceFactory) {
        self.factory = factory
    }

    public var body: some View {
        DrawingRootView(drawingService: factory.drawingService)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(factory: ServiceFactoryStub())
    }
}
