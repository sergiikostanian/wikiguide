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
        let imageFiles = apiModel.images?.map({$0.title}) ?? []
        return WikiArticleDetails(pageId: apiModel.pageid, 
                                  title: apiModel.title, 
                                  description: apiModel.description ?? "", 
                                  imageFiles: imageFiles)
    }
    
    static func makeRouteSuggestion(from apiModel: APIModel.RouteSuggestionResponse.ResposeData.Plan.Itinerary) -> RouteSuggestion {
        var segments: [RouteSuggestion.Segment] = []
        for leg in apiModel.legs {
            let mode = RouteSuggestion.Mode(rawValue: leg.mode) ?? .walk
            let segment = RouteSuggestion.Segment(startTime: leg.startTime, 
                                                  endTime: leg.endTime, 
                                                  mode: mode, 
                                                  duration: leg.duration, 
                                                  distance: leg.distance, 
                                                  details: leg.route?.longName)
            segments.append(segment)
        }
        return RouteSuggestion(segments: segments)
    }
}
