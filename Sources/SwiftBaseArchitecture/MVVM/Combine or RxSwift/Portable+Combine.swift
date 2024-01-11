//
//  File.swift
//  
//
//  Created by Andre Elandra on 11/01/24.
//

import Foundation
import Combine

fileprivate var cancellablesAssociatedKey: UInt8 = 1

public extension Portable {
    @available(iOS 13.0, *)
    var cancellables: Set<AnyCancellable> {
        get {
            guard let cancellableNSSet = objc_getAssociatedObject(self, &cancellablesAssociatedKey) as? NSSet else {
                let newCancellables = NSSet()
                objc_setAssociatedObject(self, &cancellablesAssociatedKey, newCancellables, .OBJC_ASSOCIATION_RETAIN)
                return Set<AnyCancellable>()
            }
            let cancellableSet = cancellableNSSet.convertToSet(AnyCancellable.self)
            return cancellableSet
        }
        set {
            let newCancellables = NSSet(set: newValue)
            objc_setAssociatedObject(self, &cancellablesAssociatedKey, newCancellables, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

fileprivate extension NSSet {
    func convertToSet<T>(_ type: T.Type) -> Set<T> {
        var set = Set<T>()
        for object in self {
            if let tObject = object as? T {
                set.insert(tObject)
            }
        }
        return set
    }
}
