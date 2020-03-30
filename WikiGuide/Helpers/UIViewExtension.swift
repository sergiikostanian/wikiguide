//
//  UIViewExtension.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 29.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Adds subview along with every edge constraints with zero insets.
    /// 
    /// - Parameter view: Subview to add.
    func addSubviewAndStretchToFill(_ view: UIView) {
        addSubviewAndStretch(view, edgeInsets: .zero)
    }
    
    /// Adds subview along with every edge constraints with specified edge insets.
    ///  
    /// - Parameters:
    ///   - view: Subview to add.
    ///   - edgeInsets: Edge insets that will be applied to edge constraints constants.
    func addSubviewAndStretch(_ view: UIView, edgeInsets: UIEdgeInsets) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        view.topAnchor.constraint(equalTo: topAnchor, constant: edgeInsets.top).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: edgeInsets.left).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: edgeInsets.right).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: edgeInsets.bottom).isActive = true
    }
}

