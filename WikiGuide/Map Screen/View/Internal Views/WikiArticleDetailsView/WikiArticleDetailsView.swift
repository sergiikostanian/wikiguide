//
//  WikiArticleDetailsView.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 29.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

final class WikiArticleDetailsView: UIView {
    
    enum Mode {
        case allDetails
        case routeSuggestionOnly
    }
    
    // MARK: Callback Blocks
    var didTapOpenInWiki: (() -> Void)?
    var didTapGetThere: (() -> Void)?

    // MARK: Public Properties
    var mode: Mode = .allDetails {
        didSet { didSetMode(mode) }
    }
    var images: [UIImage] = [] {
        didSet { didSetImages(images) }
    }
    var routeSuggestion: RouteSuggestion? {
        didSet { didSetRouteSuggestion(routeSuggestion) }
    }
    
    // MARK: Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var imagesLoadingIndicatior: UIActivityIndicatorView!
    @IBOutlet private weak var imagesCollectionView: UICollectionView!
    
    @IBOutlet private weak var openWikiButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var getThereButton: UIButton!
    
    @IBOutlet private weak var routeSuggestionLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var routeSuggestionView: UIView!
    @IBOutlet private weak var routeView: RouteView!
    
    @IBOutlet private weak var hidingConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath

        switch mode {
        case .allDetails:
            scrollView.contentInset.top = bounds.height / 3

        case .routeSuggestionOnly:
            scrollView.contentInset.top = bounds.height - (safeAreaInsets.bottom + 100)
        }
        scrollView.contentOffset.y = -scrollView.contentInset.top
    }
    
    // MARK: - Public Methods
    func fill(with articleDetails: WikiArticleDetails) {
        titleLabel.text = articleDetails.title.capitalized
        descriptionLabel.text = articleDetails.description.capitalized
    }
    
    func show(_ completion: (() -> Void)? = nil) {
        hidingConstraint?.isActive = false
        UIView.animate(withDuration: 0.3, animations: { 
            self.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
    
    func hide(_ completion: (() -> Void)? = nil) {
        hidingConstraint?.isActive = true
        UIView.animate(withDuration: 0.3, animations: { 
            self.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
    
    // MARK: - Setup
    private func setup() {        
        titleLabel.text = nil
        descriptionLabel.text = nil
        imagesCollectionView.isHidden = true
        imagesCollectionView.register(ArticleImageCell.self, forCellWithReuseIdentifier: ArticleImageCell.key)
        
        contentView.layer.cornerRadius = 15
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowOpacity = 0.25
        contentView.layer.shadowRadius = 3.0
        contentView.layer.masksToBounds = false
        
        routeSuggestionView.isHidden = true
        
        hidingConstraint.isActive = true
        layoutIfNeeded()
    }
    
    // MARK: - Event Handlers    
    @IBAction func openWikiButtonTapped(_ sender: UIButton) {
        didTapOpenInWiki?()
    }
    
    @IBAction func getThereButtonTapped(_ sender: UIButton) {
        didTapGetThere?()
    }
    
    private func didSetMode(_ mode: Mode) {
        switch mode {
        case .allDetails:
            titleLabel.isHidden = false
            descriptionLabel.isHidden = false
            imagesCollectionView.isHidden = images.isEmpty
            openWikiButton.isHidden = false
            separatorView.isHidden = false
            getThereButton.isHidden = false

        case .routeSuggestionOnly:
            titleLabel.isHidden = true
            descriptionLabel.isHidden = true
            imagesCollectionView.isHidden = true
            openWikiButton.isHidden = true
            separatorView.isHidden = true
            getThereButton.isHidden = true
        }
        layoutIfNeeded()
    }
    
    private func didSetImages(_ images: [UIImage]) {
        imagesLoadingIndicatior.stopAnimating()
        imagesCollectionView.isHidden = images.isEmpty
        imagesCollectionView.reloadData()
    }
    
    private func didSetRouteSuggestion(_ routeSuggestion: RouteSuggestion?) {
        routeSuggestionLoadingIndicator.stopAnimating()
        guard let routeSuggestion = routeSuggestion, !routeSuggestion.segments.isEmpty else { return }
        routeSuggestionView.isHidden = false
        routeView.fill(with: routeSuggestion)
        layoutIfNeeded()
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
