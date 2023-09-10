//
//  ServiceFactory.swift
//  
//
//  Created by Narumichi Kubo on 2023/09/10.
//

import Foundation

public protocol ServiceFactory {}

public final class ServiceFactoryImpl: ServiceFactory {
    public init() {}
}

public final class ServiceFactoryStub: ServiceFactory {
    public init() {}
}
