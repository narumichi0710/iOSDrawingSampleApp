//
//  DrawingService.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/16.
//

import Foundation
import Repository

public protocol DrawingService {}

public final class DrawingServiceImpl: DrawingService {
    let drawingRepository: DrawingRepository
    
    public init(
        drawingRepository: DrawingRepository
    ) {
        self.drawingRepository = drawingRepository
    }
}

