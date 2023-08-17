//
//  File.swift
//  
//
//  Created by Andre Elandra on 16/08/23.
//

import XCTest
import Foundation
import UIKit
@testable import SwiftBaseArchitecture

final class MVVMDelegateTests: XCTestCase {
    func testFetchItems() {
        let viewController = ItemListViewController()
        let viewModel = ItemListViewModel()
        viewController.bind(with: viewModel)
        XCTAssertTrue(viewController.items.isEmpty)
        viewController.setupDidLoad()
        XCTAssertFalse(viewController.items.isEmpty)
    }
}

//MARK: - Model

fileprivate struct Item {
    let name: String
    let price: Double
}

// MARK: - View Model

fileprivate class ItemListViewModel: ViewModelDelegable {
    typealias Delegate = ItemListViewModelDelegate
    weak var delegate: Delegate?
    
    private var items: [Item] = []

    func fetchItems() {
        items = [
            Item(name: "Item 1", price: 10.0),
            Item(name: "Item 2", price: 20.0),
            Item(name: "Item 3", price: 30.0)
        ]
        delegate?.viewModelDidUpdateItems(items)
    }
}

// MARK: - View Controller

fileprivate protocol ItemListViewModelDelegate: AnyObject {
    func viewModelDidUpdateItems(_ items: [Item])
}

fileprivate class ItemListViewController: UIViewController, BindableDelegate, ItemListViewModelDelegate {
    typealias ViewModel = ItemListViewModel

    var viewModel: ViewModel?
    
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDidLoad()
    }
    
    func setupDidLoad() {
        viewModel?.fetchItems()
    }
    
    func viewModelDidUpdateItems(_ items: [Item]) {
        self.items = items
    }
}
