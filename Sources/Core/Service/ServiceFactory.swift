//
//  ServiceFactory.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/10.
//

import Foundation
import Repository

public protocol ServiceFactory {
    var drawingService: DrawingService { get }
}

public final class ServiceFactoryImpl: ServiceFactory {
    public lazy var drawingService: DrawingService = DrawingServiceImpl(
        drawingRepository: DrawingRepositoryImpl()
    )
    
    public init() {}
}

public final class ServiceFactoryStub: ServiceFactory {
    public lazy var drawingService: DrawingService = DrawingServiceStub()
    
    public init() {}
}
