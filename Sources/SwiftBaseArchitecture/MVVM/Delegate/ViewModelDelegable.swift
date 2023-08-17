//
//  File.swift
//  
//
//  Created by Andre Elandra on 16/08/23.
//

import Foundation

public protocol ViewModelDelegable {
    associatedtype Delegate
    
    /// Make sure to use `weak` to prevent retain cycles.
    var delegate: Delegate? { get set }
}
