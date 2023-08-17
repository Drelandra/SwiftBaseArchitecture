//
//  File.swift
//  
//
//  Created by Andre Elandra on 16/08/23.
//

import Foundation
import UIKit

public protocol Routing {
    /// Make sure to use `weak` to prevent retain cycles.
    var baseViewController: UIViewController? { get set }
    
    init?(baseViewController: UIViewController)
}

public extension Routing {
    init?(baseViewController: UIViewController) { nil }
}
