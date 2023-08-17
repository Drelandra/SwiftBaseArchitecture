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

final class VIPERTests: XCTestCase {
    func testFetchItemsThenRouteToProfile() {
        let itemVC = ItemListViewController()
        let itemListPresenter = ItemListPresenter()
        let itemListRouter = ItemListRouter(baseViewController: itemVC)
        let itemListInteractor = ItemListInteractor()
        itemVC.bind(with: itemListPresenter)
        itemListPresenter.bind(with: itemVC, interactor: itemListInteractor, router: itemListRouter)
        itemListInteractor.bind(with: itemListPresenter)
        XCTAssertTrue(itemVC.items.isEmpty)
        itemVC.setupDidLoad()
        XCTAssertFalse(itemVC.items.isEmpty)
        XCTAssertFalse(itemListRouter.isRouting)
        itemVC.routeToProfile()
        XCTAssertTrue(itemListRouter.isRouting)
    }
}

//MARK: - Model

fileprivate struct Item {
    let name: String
    let price: Double
}

fileprivate struct Profile {
    let username: String
}

// MARK: - Interactors

fileprivate protocol ItemListInteractorProtocol: AnyObject {
    func fetchItems()
}

fileprivate class ItemListInteractor: ItemListInteractorProtocol, BindableInteractor {
    
    typealias Presenter = ItemListPresenterProtocol
    weak var presenter: ItemListPresenterProtocol?

    func fetchItems() {
        let items = [
            Item(name: "Item 1", price: 10.0),
            Item(name: "Item 2", price: 20.0),
            Item(name: "Item 3", price: 30.0)
        ]
        presenter?.itemsFetched(items)
    }
}

fileprivate protocol ProfileInteractorProtocol: AnyObject {
    func fetchProfile()
}

fileprivate class ProfileInteractor: ProfileInteractorProtocol {
    
    weak var presenter: ProfilePresenterProtocol?

    func fetchProfile() {
        let profile = Profile(username: "dre")
        presenter?.profileFetched(profile)
    }
}

// MARK: - Presenters

fileprivate protocol ItemListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func itemsFetched(_ items: [Item])
    func routeToProfile()
}

fileprivate class ItemListPresenter: ItemListPresenterProtocol, BindablePresenter {
    typealias View = ItemListViewProtocol
    typealias Interactor = ItemListInteractorProtocol
    typealias Router = ItemListRouting
    
    weak var view: View?
    var interactor: Interactor?
    var router: Router?
    
    func viewDidLoad() {
        interactor?.fetchItems()
    }
    
    func itemsFetched(_ items: [Item]) {
        view?.displayItems(items)
    }
    
    func routeToProfile() {
        router?.routeToProfile()
    }
}

fileprivate protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func profileFetched(_ profile: Profile)
}

fileprivate class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    var interactor: ProfileInteractorProtocol?
    
    func viewDidLoad() {
        interactor?.fetchProfile()
    }
    
    func profileFetched(_ profile: Profile) {
        view?.displayProfile(profile)
    }
}

//MARK: - View Controllers

fileprivate protocol ItemListViewProtocol: AnyObject {
    func displayItems(_ items: [Item])
}

fileprivate class ItemListViewController: UIViewController, ItemListViewProtocol, BindableView {
    typealias Presenter = ItemListPresenterProtocol
    
    var presenter: Presenter?
    
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDidLoad()
    }
    
    func setupDidLoad() {
        presenter?.viewDidLoad()
    }
    
    func displayItems(_ items: [Item]) {
        self.items = items
    }
    
    func routeToProfile() {
        presenter?.routeToProfile()
    }
}

fileprivate protocol ProfileViewProtocol: AnyObject {
    func displayProfile(_ profile: Profile)
}

fileprivate class ProfileViewController: UIViewController, ProfileViewProtocol, BindableView {
    
    typealias Presenter = ProfilePresenterProtocol
    var presenter: Presenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func displayProfile(_ profile: Profile) {
        title = profile.username
    }
}

//MARK: - Routers

fileprivate protocol ItemListRouting: Routing {
    func routeToProfile()
}

fileprivate class ItemListRouter: ItemListRouting {
    weak var baseViewController: UIViewController?
    
    var isRouting: Bool = false
    
    required init(baseViewController: UIViewController) {
        self.baseViewController = baseViewController
    }
    
    func routeToProfile() {
        isRouting = true
    }
}
