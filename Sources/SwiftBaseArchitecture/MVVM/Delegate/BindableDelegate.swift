//
//  File.swift
//  
//
//  Created by Andre Elandra on 16/08/23.
//

import Foundation

public protocol BindableDelegate: AnyObject {
    associatedtype ViewModel: ViewModelDelegable
    
    var viewModel: ViewModel? { get set }
    func bind(with viewModel: ViewModel)
}

public extension BindableDelegate {
    func unbind() {
        viewModel = nil
    }
    
    func bind(with viewModel: ViewModel) {
        unbind()
        self.viewModel = viewModel
        self.viewModel?.delegate = self as? Self.ViewModel.Delegate
    }
}
