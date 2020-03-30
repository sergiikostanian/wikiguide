//
//  MapViewModeling.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 29.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

/**
 This protocol defines Map ViewModel delegation methods.
 */
protocol MapViewModelDelegate: AnyObject {
}

/**
 Map screen ViewModel protocol.
 */
protocol MapViewModeling {
    
    typealias Location = (latitude: Double, longitude: Double)
    
    var delegate: MapViewModelDelegate? { get set }
    
    func fetchUserLocation(completion: @escaping (Result<Location, Error>) -> Void)
    
    func fetchWikiArticles(for location: Location, completion: @escaping (Result<[WikiArticle], Error>) -> Void)
    func fetchWikiArticleDetails(by id: Int, completion: @escaping (Result<WikiArticleDetails, Error>) -> Void)
}
