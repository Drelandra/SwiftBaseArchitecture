//
//  File.swift
//  
//
//  Created by Andre Elandra on 16/08/23.
//

import Foundation

public protocol BindablePresenter: AnyObject {
    associatedtype View
    associatedtype Interactor
    associatedtype Router
    
    /// Make sure to use `weak` to prevent retain cycles.
    var view: View? { get set }
    var interactor: Interactor? { get set }
    var router: Router? { get set }
    
    func bind(with view: View, interactor: Interactor, router: Router)
}

public extension BindablePresenter {
    func unbind() {
        self.view = nil
        self.interactor = nil
        self.router = nil
    }
    
    func bind(with view: View, interactor: Interactor) {
        unbind()
        self.view = view
        self.interactor = interactor
        self.router = nil
    }
    
    func bind(with view: View, interactor: Interactor, router: Router) {
        unbind()
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}
