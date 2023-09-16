//
//  DrawingRootView.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import SwiftUI
import Service

public struct DrawingRootView: View {
    @StateObject private var interactor: DrawingInteractor
    
    public init (
        drawingService: DrawingService
    ) {
        _interactor = .init(wrappedValue: .init(drawingService: drawingService))
    }
    
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingRootView(drawingService: ServiceFactoryStub().drawingService)
    }
}
