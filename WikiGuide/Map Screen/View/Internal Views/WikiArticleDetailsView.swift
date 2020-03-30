//
//  WikiArticleDetailsView.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 29.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

final class WikiArticleDetailsView: UIView {
    
    // MARK: Callback Blocks
    var didTapOverlay: (() -> Void)?
    var didTapOpenInWiki: (() -> Void)?
    var didTapGetThere: (() -> Void)?

    // MARK: Public Properties
    var images: [UIImage] = [] {
        didSet {
            didSetImages(images)
        }
    }
    
    // MARK: Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var imagesLoadingIndicatior: UIActivityIndicatorView!
    @IBOutlet private weak var imagesCollectionView: UICollectionView!
    @IBOutlet private weak var hidingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.roundCorners([.topLeft, .topRight], radius: 12)
    }
    
    // MARK: - Public Methods
    func fill(with articleDetails: WikiArticleDetails) {
        titleLabel.text = articleDetails.title.capitalized
        descriptionLabel.text = articleDetails.description.capitalized
    }
    
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
        setupOverlayTapGestureRecognizer()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
        imagesCollectionView.isHidden = true
        imagesCollectionView.register(ArticleImageCell.self, forCellWithReuseIdentifier: ArticleImageCell.key)
        
        hidingConstraint.isActive = true
        layoutIfNeeded()
    }
    
    private func setupOverlayTapGestureRecognizer() {
        let overlayTapGestureRecognizer = UITapGestureRecognizer()
        overlayTapGestureRecognizer.addTarget(self, action: #selector(overlayTapped))
        addGestureRecognizer(overlayTapGestureRecognizer)
    }
    
    // MARK: - Event Handlers
    @objc private func overlayTapped() {
        didTapOverlay?()
    }
    
    @IBAction func openWikiButtonTapped(_ sender: UIButton) {
        didTapOpenInWiki?()
    }
    
    @IBAction func getThereButtonTapped(_ sender: UIButton) {
        didTapGetThere?()
    }
    
    private func didSetImages(_ images: [UIImage]) {
        imagesLoadingIndicatior.isHidden = true
        imagesCollectionView.isHidden = images.isEmpty
        imagesCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension WikiArticleDetailsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleImageCell.key, for: indexPath) as! ArticleImageCell
        cell.image = images[indexPath.item]
        return cell
    }
}
