//
//  CustomLabel.swift
//  TESTCollectionVIew
//
//  Created by Kseniya Smirnova on 10.10.22.
//

import UIKit

class CustomLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = .black
        numberOfLines = 0
        textAlignment = .center
        font = Fonts.latoMedium.rawValue
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
