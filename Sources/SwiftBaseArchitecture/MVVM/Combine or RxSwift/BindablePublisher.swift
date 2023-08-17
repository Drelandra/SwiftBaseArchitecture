//
//  File.swift
//  
//
//  Created by Andre Elandra on 16/08/23.
//

import Foundation

public protocol BindablePublisher: AnyObject {
    /// Implement a protocol for inputting to view model.
    associatedtype Responder
    /// Implement a protocol for outputting to view with publisher or observer (e.g. Combine, RxSwift).
    associatedtype Publisher

    var responder: Responder? { get set }
    
    func bind(with responder: Responder, and publisher: Publisher)
    func publish(_ publishable: Publisher)
}

public extension BindablePublisher {
    func unbind() {
        responder = nil
    }
    
    func bind(with responder: Responder, and publisher: Publisher) {
        unbind()
        self.responder = responder
        publish(publisher)
    }
    
    func bind<P: Portable>(with port: P) where P.Input == Responder, P.Output == Publisher {
        unbind()
        bind(with: port.input, and: port.output)
    }
}
