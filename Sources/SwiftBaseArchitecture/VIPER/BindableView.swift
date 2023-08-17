//
//  File.swift
//  
//
//  Created by Andre Elandra on 16/08/23.
//

import Foundation

public protocol BindableView: AnyObject {
    associatedtype Presenter

    var presenter: Presenter? { get set }
    func bind(with presenter: Presenter)
}

public extension BindableView {
    func unbind() {
        self.presenter = nil
    }
    
    func bind(with presenter: Presenter) {
        unbind()
        self.presenter = presenter
    }
}
