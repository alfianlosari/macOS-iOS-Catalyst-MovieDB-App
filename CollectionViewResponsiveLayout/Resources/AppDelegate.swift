//
//  AppDelegate.swift
//  CollectionViewResponsiveLayout
//
//  Created by Alfian Losari on 2/8/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var sceneDelegate: SceneDelegate {
        return UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
    }
    
    var tabBarController: UITabBarController {
        return sceneDelegate.window!.rootViewController as! UITabBarController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupDarkTheme()
        return true
    }
    
    private func setupDarkTheme() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().tintColor = UIColor.white
    }
    
    override func buildCommands(with builder: UICommandBuilder) {
        guard builder.system == .main else { return }
        builder.remove(menu: .format)
        builder.remove(menu: .edit)
        
        let list = UICommand(__title: LayoutOption.list.description, action: #selector(listSelected(_:)), propertyList: nil)
        let grids = UICommand(__title: LayoutOption.smallGrid.description, action: #selector(sGridSelected(_:)), propertyList: nil)
        let gridl = UICommand(__title: LayoutOption.largeGrid.description, action: #selector(lGridSelected(_:)), propertyList: nil)
        let layoutListMenu = UIMenu<UICommand>.create(title: "Layout", children: [list, grids, gridl])
        builder.insertSibling(layoutListMenu, afterMenu: .file)
        
        let nowPlaying = UICommand(__title: Endpoint.nowPlaying.description, action: #selector(nowPlayingSelected(_:)), propertyList: nil)
        let upcoming = UICommand(__title: Endpoint.upcoming.description, action: #selector(upcomingSelected(_:)), propertyList: nil)
        let popular = UICommand(__title: Endpoint.popular.description, action: #selector(popularSelected(_:)), propertyList: nil)
        let topRated = UICommand(__title: Endpoint.topRated.description, action: #selector(topRatedSelected(_:)), propertyList: nil)
        let categoryListMenu = UIMenu<UICommand>.create(title: "Category", children: [nowPlaying, upcoming, popular, topRated])
        
        builder.insertSibling(categoryListMenu, beforeMenu: .view)
    }
    
    @objc func listSelected(_ sender: Any) {
        selectLayout(layout: .list)
    }
    
    @objc func sGridSelected(_ sender: Any) {
        selectLayout(layout: .smallGrid)
    }
    
    @objc func lGridSelected(_ sender: Any) {
        selectLayout(layout: .largeGrid)
    }
    
    @objc func nowPlayingSelected(_ sender: Any) {
        selectCategory(index: 0)
    }
    
    @objc func upcomingSelected(_ sender: Any) {
        selectCategory(index: 1)
    }
    
    @objc func popularSelected(_ sender: Any) {
        selectCategory(index: 2)
    }
    
    @objc func topRatedSelected(_ sender: Any) {
        selectCategory(index: 3)
    }
    
    private func selectLayout(layout: LayoutOption) {
        NotificationCenter.default.post(name: layoutChangeNotification, object: nil, userInfo: ["layout": layout])
        #if targetEnvironment(UIKitForMac)
            sceneDelegate.layoutGroup?.selectedIndex = layout.rawValue
        #endif
    }
    
    func selectCategory(index: Int) {
        #if targetEnvironment(UIKitForMac)
            sceneDelegate.categoryGroup?.selectedIndex = index
        #endif
        
        tabBarController.selectedIndex = index
    }

}
