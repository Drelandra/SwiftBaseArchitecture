//
//  File.swift
//  
//
//  Created by Andre Elandra on 17/08/23.
//

import Foundation

public protocol Portable: AnyObject {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

public extension Portable {
    var input: Input {
        guard let portInput: Input = self as? Input else {
            fatalError("Please implement input getter manually or implement Input type to your Portable object.\nReason: Input type is not implemented in Portable.")
        }
        return portInput
    }
    
    var output: Output {
        guard let portOutput: Output = self as? Output else {
            fatalError("Please implement output getter manually or implement Ouput type to your Portable object.\nReason: Ouput type is not implemented in Portable.")
        }
        return portOutput
    }
}
