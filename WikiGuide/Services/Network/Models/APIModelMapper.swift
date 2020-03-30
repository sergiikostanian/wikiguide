//
//  APIModelMapper.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 29.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

/**
 This is an entities factory that maps API models into according entities.
 */
enum APIModelMapper {
    
    static func makeWikiArticle(from apiModel: APIModel.WikiArticlesResponse.Query.Article) -> WikiArticle {
        return WikiArticle(pageId: apiModel.pageid, 
                           title: apiModel.title, 
                           latitude: apiModel.lat, 
                           longitude: apiModel.lon)
    }
    
    static func makeWikiArticleDetails(from apiModel: APIModel.WikiArticleDetailsResponse.Query.ArticleDetails) -> WikiArticleDetails {
        return WikiArticleDetails(pageId: apiModel.pageid, 
                                  title: apiModel.title, 
                                  description: apiModel.description, 
                                  images: apiModel.images.map({$0.title}))
    }
}
