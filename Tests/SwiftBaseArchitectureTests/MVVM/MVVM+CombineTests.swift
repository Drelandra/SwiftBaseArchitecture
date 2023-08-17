//
//  File.swift
//  
//
//  Created by Andre Elandra on 16/08/23.
//

import XCTest
import Foundation
import UIKit
import Combine
@testable import SwiftBaseArchitecture

@available(iOS 13.0, *)
final class MVVMCombineTests: XCTestCase {
    
    func testFetchItems() {
        let viewController = ItemListViewController()
        let viewModel = ItemListViewModel()
        viewController.bind(with: viewModel)
        viewController.setupDidLoad()
        XCTAssertTrue(viewController.items.isEmpty)
        wait(for: 3)
        XCTAssertFalse(viewController.items.isEmpty)
    }
}

//MARK: - Model

fileprivate struct Item {
    let name: String
    let price: Double
}

// MARK: - View Model

@available(iOS 13.0, *)
fileprivate class ItemListViewModel: Portable, ItemListPublishable {
    typealias Input = ItemListResponder
    typealias Output = ItemListPublishable
    
    private var items: [Item] = []
    
    private var itemsSubject = PassthroughSubject<[Item], Never>()
    
    var itemsPublisher: AnyPublisher<[Item], Never> {
        return itemsSubject.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, *)
extension ItemListViewModel: ItemListResponder {
    func fetchItems() {
        items = [
            Item(name: "Item 1", price: 10.0),
            Item(name: "Item 2", price: 20.0),
            Item(name: "Item 3", price: 30.0)
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.itemsSubject.send(self.items)
        }
    }
}

//MARK: - View Controller

fileprivate protocol ItemListResponder: AnyObject {
    func fetchItems()
}

@available(iOS 13.0, *)
fileprivate protocol ItemListPublishable {
    var itemsPublisher: AnyPublisher<[Item], Never> { get }
}

@available(iOS 13.0, *)
fileprivate class ItemListViewController: UIViewController, BindablePublisher {
    typealias Responder = ItemListResponder
    typealias Publisher = ItemListPublishable
    
    var responder: ItemListResponder?
    
    var items: [Item] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDidLoad()
    }
    
    func setupDidLoad() {
        responder?.fetchItems()
    }
    
    func publish(_ publishable: Publisher) {
        publishable.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                guard let self = self else { return }
                self.items = items
            }
            .store(in: &cancellables)
    }
}
