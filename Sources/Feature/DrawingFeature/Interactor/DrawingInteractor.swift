//
//  DrawingInteractor.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import Foundation
import SwiftUI
import Service

public class DrawingInteractor: ObservableObject {
    private let drawingService: DrawingService
    
    public init(drawingService: DrawingService) {
        self.drawingService = drawingService
    }
}
