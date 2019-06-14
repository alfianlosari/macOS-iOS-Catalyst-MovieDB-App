//
//  SceneDelegate.swift
//  xxx
//
//  Created by Alfian Losari on 13/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit

let layoutChangeNotification = NSNotification.Name("movieDBLayoutChangeNotification")

#if targetEnvironment(UIKitForMac)
class SceneDelegate: UIResponder, UIWindowSceneDelegate, NSToolbarDelegate {
    
    var window: UIWindow?
    
    var layoutGroup: NSToolbarItemGroup?
    var categoryGroup: NSToolbarItemGroup?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let movieService = MovieStore.shared
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = MainTabBarViewController()
        tabBarController.viewControllers = Endpoint.allCases.map({ (endpoint) -> UIViewController in
            let movieListVC = MovieListViewController(endpoint: endpoint, movieService: movieService)
            let navVC = UINavigationController(rootViewController: movieListVC)
            

            navVC.navigationBar.isHidden = true
            
            return navVC
        })
        
        if let titleBar = windowScene.titlebar {
            tabBarController.tabBar.isHidden = true
            
            let toolbar = NSToolbar(identifier: .movieDB)
            toolbar.delegate = self
            toolbar.allowsUserCustomization = false
            toolbar.centeredItemIdentifier = .category
            toolbar.insertItem(withItemIdentifier: .layout, at: 0)
            
            titleBar.titleVisibility = .hidden
            titleBar.toolbar = toolbar
        }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
        self.window?.windowScene = windowScene
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case .layout:
            let titles = LayoutOption.allCases.map { $0.description }
            let group = NSToolbarItemGroup.init(itemIdentifier: .layout, titles: titles, selectionMode: .selectOne, labels: titles, target: self, action: #selector(toolbarGroupSelectionChanged))
            self.layoutGroup = group
            group.setSelected(true, at: 0)
            return group
            
        case .category:
            let titles = Endpoint.allCases.map { $0.description }
            let group = NSToolbarItemGroup.init(itemIdentifier: .category, titles: titles, selectionMode: .selectOne, labels: titles, target: self, action: #selector(toolbarGroupSelectionChanged))
            self.categoryGroup = group
            group.setSelected(true, at: 0)
            return group
            
        default:
            return nil
            
        }
    }
    
    @objc func toolbarGroupSelectionChanged(sender: NSToolbarItemGroup) {
        
        switch sender.itemIdentifier {
        case .layout:
            guard let layoutOption = LayoutOption(rawValue: sender.selectedIndex) else {
                return
            }
            NotificationCenter.default.post(name: layoutChangeNotification, object: nil, userInfo: ["layout": layoutOption])
            
        case .category:
            guard let tabBar = self.window?.rootViewController as? UITabBarController else {
                return
            }
            tabBar.selectedIndex = sender.selectedIndex
            
        default:
            return
        }
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.layout, .category]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.layout, .category]
    }
}


fileprivate extension NSToolbar.Identifier {
    static let movieDB = NSToolbar.Identifier("movieDB")
    
}


fileprivate extension NSToolbarItem.Identifier {
    static let layout = NSToolbarItem.Identifier("Layout")
    static let category = NSToolbarItem.Identifier("Category")
}



#else

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let movieService = MovieStore.shared
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = MainTabBarViewController()
        tabBarController.viewControllers = Endpoint.allCases.map({ (endpoint) -> UIViewController in
            let movieListVC = MovieListViewController(endpoint: endpoint, movieService: movieService)
            let navVC = UINavigationController(rootViewController: movieListVC)
            
            return navVC
        })
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
        self.window?.windowScene = windowScene
    }
}

#endif


