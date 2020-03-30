//
//  WikiService.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation
import UIKit.UIImage

/**
 This service provides data from Wikipedia available via public API.
 For more detail see [Wikipedia API](https://en.wikipedia.org/w/api.php).
 */
public protocol WikiService {
    
    /// Fetches wiki articles having specified coordinates that are located in a nearby area.
    func fetchArticles(latitude: Double, longitude: Double, completion: @escaping (Result<[WikiArticle], Error>) -> Void)
    /// Fetches wiki article details by specified article id.
    func fetchArticleDetails(by id: Int, completion: @escaping (Result<WikiArticleDetails, Error>) -> Void)
    /// Fetches wiki image by file title.
    func fetchImage(file: String, completion: @escaping (UIImage?) -> Void)
    
}
