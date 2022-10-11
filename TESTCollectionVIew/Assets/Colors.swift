//
//  Colors.swift
//  TESTCollectionVIew
//
//  Created by Kseniya Smirnova on 10.10.22.
//

import UIKit

enum Colors {
    case greenColor
    case yellowColor
    case grayColor
    
    var rawValue: UIColor {
        switch self {
        case .greenColor: return UIColor(named: "Green") ?? .green
        case .yellowColor: return UIColor(named: "Yellow") ?? .yellow
        case .grayColor: return UIColor(named: "Gray") ?? .lightGray
        }
    }
}
