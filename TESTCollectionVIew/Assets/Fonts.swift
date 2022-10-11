//
//  Fonts.swift
//  TESTCollectionVIew
//
//  Created by Kseniya Smirnova on 11.10.22.
//

import UIKit

enum Fonts {
    case latoMedium
    
    var rawValue: UIFont {
        switch self {
        case .latoMedium: return UIFont(name: "Lato-Medium", size: 14) ?? .systemFont(ofSize: 14)
        }
    }
}
