//
//  WikiArticleDetailsView.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 29.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

final class WikiArticleDetailsView: UIView {
    
    var didTapOverlay: (() -> Void)?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var hidingConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Public Methods
    
    func show(_ completion: (() -> Void)? = nil) {
        hidingConstraint?.isActive = false
        UIView.animate(withDuration: 0.3, animations: { 
            self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            self.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
    
    func hide(_ completion: (() -> Void)? = nil) {
        hidingConstraint?.isActive = true
        UIView.animate(withDuration: 0.3, animations: { 
            self.backgroundColor = UIColor.clear
            self.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = UIColor.clear
        
        setupScrollView()
        setupContentView()
        setupOverlayTapGestureRecognizer()
        
        layoutIfNeeded()
    }
    
    private func setupScrollView() {
        scrollView.backgroundColor = .systemYellow
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        scrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        
        hidingConstraint = scrollView.topAnchor.constraint(equalTo: bottomAnchor)
        hidingConstraint?.isActive = true
        
        let bottomConstraint = bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        bottomConstraint.priority = .defaultHigh
        bottomConstraint.isActive = true
    }
    
    private func setupContentView() {
        contentView.backgroundColor = .systemYellow
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func setupOverlayTapGestureRecognizer() {
        let overlayTapGestureRecognizer = UITapGestureRecognizer()
        overlayTapGestureRecognizer.addTarget(self, action: #selector(overlayTapped))
        addGestureRecognizer(overlayTapGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @objc private func overlayTapped() {
        didTapOverlay?()
    }
}
