//
//  LoadingInfoView.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 01.04.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

final class LoadingInfoView: UIView {
    
    var title: String = "" {
        didSet { label.text = title }
    }
    
    private let loadingIndicatior = UIActivityIndicatorView(style: .whiteLarge)
    private let label = UILabel()
    private var hidingConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func show(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 100).isActive = true
        
        let top = topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        top.priority = .defaultHigh
        top.isActive = true
        
        hidingConstraint = view.topAnchor.constraint(equalTo: bottomAnchor, constant: 16)
        hidingConstraint?.isActive = true
        view.layoutIfNeeded()
        
        hidingConstraint?.isActive = false
        UIView.animate(withDuration: 0.3) {
            view.layoutIfNeeded()
        }
    }
    
    func hide() {
        hidingConstraint?.isActive = true
        UIView.animate(withDuration: 0.3, animations: { 
            self.superview?.layoutIfNeeded()
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    private func setup() {
        addShadow()
        
        backgroundColor = .white
        
        loadingIndicatior.color = #colorLiteral(red: 0.3048620522, green: 0.345874846, blue: 0.3874318004, alpha: 1)
        loadingIndicatior.startAnimating()
        loadingIndicatior.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicatior)
        loadingIndicatior.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        loadingIndicatior.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        label.font = UIFont(name: "GillSans-SemiBold", size: 18)
        label.textColor = #colorLiteral(red: 0.3048620522, green: 0.345874846, blue: 0.3874318004, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.topAnchor.constraint(equalTo: loadingIndicatior.bottomAnchor, constant: 4).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 16).isActive = true
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
    }
    
    private func addShadow() {
        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 3.0
        layer.masksToBounds = false
    }
}
