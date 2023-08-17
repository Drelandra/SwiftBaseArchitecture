//
//  File.swift
//  
//
//  Created by Andre Elandra on 16/08/23.
//

import Foundation

public protocol BindableInteractor: AnyObject {
    associatedtype Presenter
    
    /// Make sure to use `weak` to prevent retain cycles.
    var presenter: Presenter? { get set }
    
    func bind(with presenter: Presenter)
}

public extension BindableInteractor {
    func unbind() {
        self.presenter = nil
    }
    
    func bind(with presenter: Presenter) {
        unbind()
        self.presenter = presenter
    }
}
