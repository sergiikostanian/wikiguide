//
//  WikiAPI.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation
import Combine
import CoreLocation.CLLocation

enum WikiError: Error {
    case fetchArticlesBadRequest
}

public class WikiAPI {
    
    private let baseURL = URL(string: "https://en.wikipedia.org/w/api.php")!
    private let httpClient = HTTPClient()

}

extension WikiAPI: WikiService {
    
    public func fetchArticles(latitude: Double, longitude: Double, completion: @escaping (Result<[WikiArticle], Error>) -> Void) {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            completion(.failure(WikiError.fetchArticlesBadRequest))
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "list", value: "geosearch"),
            URLQueryItem(name: "gsradius", value: "1000"),
            URLQueryItem(name: "gscoord", value: "\(latitude)|\(longitude)"),
            URLQueryItem(name: "gslimit", value: "50"),
            URLQueryItem(name: "format", value: "json")
        ]
        
        guard let url = components.url else {
            completion(.failure(WikiError.fetchArticlesBadRequest))
            return
        }
        
        httpClient.perform(URLRequest(url: url)) { (result: Result<APIModel.WikiArticlesResponse, Error>) in
            switch result {
            case .success(let response):
                let articles = response.query.geosearch.map({ APIModelMapper.makeWikiArticle(from: $0) })
                completion(.success(articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// The assignments requirement clearly states that the app must run in native iOS 12
    /// and unfortunately `Combine` framework is available only from iOS 13, but anyway 
    /// I decided to implement example method that uses Combine to show how would I do this 
    /// if deployment target will be iOS 13.
    /// 
    /// Usage Example:
    /// 
    /// ````
    /// let token = wikiAPI.fetchArticles(latitude: 12, longitude: 12).sink(receiveCompletion: { (result) in
    /// }, receiveValue: { (articles) in
    /// })
    /// ````
//    @available(iOS 13.0, *)
//    public func fetchArticles(latitude: Double, longitude: Double) throws -> AnyPublisher<[WikiArticle], Error> {
//        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
//            throw WikiError.fetchArticlesBadRequest
//        }
//        
//        components.queryItems = [
//            URLQueryItem(name: "action", value: "query"),
//            URLQueryItem(name: "list", value: "geosearch"),
//            URLQueryItem(name: "gsradius", value: "1000"),
//            URLQueryItem(name: "gscoord", value: "\(latitude)|\(longitude)"),
//            URLQueryItem(name: "gslimit", value: "50"),
//            URLQueryItem(name: "format", value: "json")
//        ]
//        
//        guard let url = components.url else {
//            throw WikiError.fetchArticlesBadRequest
//        }
//        
//        return httpClient.perform(URLRequest(url: url)).eraseToAnyPublisher()
//    }
}
