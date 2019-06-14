//
//  MainTabBarViewController.swift
//  CollectionViewResponsiveLayout
//
//  Created by Alfian Losari on 13/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit

#if targetEnvironment(UIKitForMac)

class MainTabBarViewController: UITabBarController, NSTouchBarDelegate {
    
    var sceneDelegate: SceneDelegate {
        return UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
    }
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .movieDB
        
        var itemIdentifiers = LayoutOption.allCases.map { $0.touchBarItemIdentifier }
        itemIdentifiers.append(contentsOf: Endpoint.allCases.map { $0.touchBarItemIdentifier })
        touchBar.defaultItemIdentifiers = itemIdentifiers
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let item: NSSliderTouchBarItem
        if let layoutOption = LayoutOption(touchBarItemIdentifier: identifier) {
            item = NSSliderTouchBarItem(identifier: identifier)
            item.label = layoutOption.description
        } else if let endpoint = Endpoint(touchBarItemIdentifier: identifier) {
            item = NSSliderTouchBarItem(identifier: identifier)
            item.label = endpoint.description
        } else {
            return nil
        }
        
        item.setValue(1, forKey: "minimumSliderWidth")
        item.setValue(3, forKey: "maximumSliderWidth")
        item.action = #selector(self.changed(_:))
        item.target = self
        return item
    }
    
    
    @objc func changed(_ sender: NSSliderTouchBarItem) {
        if let layoutOption = LayoutOption(touchBarItemIdentifier: sender.identifier) {
            self.selectLayout(layout: layoutOption)
        } else if let endpoint = Endpoint(touchBarItemIdentifier: sender.identifier) {
            self.selectCategory(index: endpoint.index)
        }
    }
    
    private func selectLayout(layout: LayoutOption) {
        NotificationCenter.default.post(name: layoutChangeNotification, object: nil, userInfo: ["layout": layout])
        sceneDelegate.layoutGroup?.selectedIndex = layout.rawValue
    }
    
    private func selectCategory(index: Int) {
        sceneDelegate.categoryGroup?.selectedIndex = index
        self.selectedIndex = index
    }
    
}

fileprivate extension Endpoint {
    
    init?(touchBarItemIdentifier: NSTouchBarItem.Identifier) {
        let allCases = Endpoint.allCases
        if let _case = allCases.first(where: {  $0.touchBarItemIdentifier ==  touchBarItemIdentifier }) {
            self = _case
            return
        }
        return nil
    }
    
    var index: Int {
        switch self {
        case .nowPlaying: return 0
        case .upcoming: return 1
        case .popular: return 2
        case .topRated: return 3
        }
    }
    
    var touchBarItemIdentifier: NSTouchBarItem.Identifier {
        switch self {
        case .nowPlaying: return NSTouchBarItem.Identifier("nowPlaying")
        case .upcoming: return NSTouchBarItem.Identifier("upcoming")
        case .popular: return NSTouchBarItem.Identifier("popular")
        case .topRated: return NSTouchBarItem.Identifier("topRated")
            
        }
    }
}

fileprivate extension LayoutOption {
    init?(touchBarItemIdentifier: NSTouchBarItem.Identifier) {
        let allCases = LayoutOption.allCases
        if let _case = allCases.first(where: {  $0.touchBarItemIdentifier ==  touchBarItemIdentifier }) {
            self = _case
            return
        }
        return nil
    }
    
    var touchBarItemIdentifier: NSTouchBarItem.Identifier {
        switch self {
        case .list: return NSTouchBarItem.Identifier("list")
        case .smallGrid: return NSTouchBarItem.Identifier("smallGrid")
        case .largeGrid: return NSTouchBarItem.Identifier("largeGrid")
        }
    }
}

fileprivate extension NSTouchBar.CustomizationIdentifier {
    static let movieDB = NSTouchBar.CustomizationIdentifier("movieDB")
}

#else
class MainTabBarViewController: UITabBarController {}
#endif


