//
//  ArticleImageCell.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 30.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

final class ArticleImageCell: UICollectionViewCell {
    
    static let key = "ArticleImageCell"
    static let defaultSize = CGSize(width: 150, height: 50)
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 4
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubviewAndStretchToFill(imageView)
    }
}
