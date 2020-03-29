//
//  WikiArticleAnnotation.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 29.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation
import MapKit

/**
 This is the `WikiArticle` wrapper that implements `MKAnnotation` protocol for displaying articles as POIs on the map. 
 */
final class WikiArticleAnnotation: NSObject, MKAnnotation {
    
    let article: WikiArticle
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: article.latitude, longitude: article.longitude) 
    }
    
    var title: String? {
        return article.title
    }
    
    init(article: WikiArticle) {
        self.article = article
        super.init()
    }
}
