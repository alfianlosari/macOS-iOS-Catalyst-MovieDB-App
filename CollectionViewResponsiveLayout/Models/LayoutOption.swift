//
//  LayoutOption.swift
//  CollectionViewResponsiveLayout
//
//  Created by Alfian Losari on 2/8/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

enum LayoutOption: Int, CaseIterable {
    
    case list
    case smallGrid
    case largeGrid
    
    
    var description: String {
        switch self {
        case .list: return "List"
        case .smallGrid: return "S Grid"
        case .largeGrid: return "L Grid"
        }
    }
    
}
