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

public class WikiAPI {
    
    private let baseURL = URL(string: "https://en.wikipedia.org")!
    private let httpClient = HTTPClient()

}

extension WikiAPI: WikiService {
    
    public func fetchArticles(latitude: Double, longitude: Double, completion: @escaping (Result<[APIModel.Article], Error>) -> Void) {
        let request = URLRequest(url: baseURL.appendingPathComponent("api.php?action=query&list=geosearch&gsradius=10000&gscoord=\(latitude)|\(longitude)&gslimit=50&format=json"))
        
        httpClient.perform(request, completion: completion)
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
    @available(iOS 13.0, *)
    public func fetchArticles(latitude: Double, longitude: Double) -> AnyPublisher<[APIModel.Article], Error> {
        let request = URLRequest(url: baseURL.appendingPathComponent("api.php?action=query&list=geosearch&gsradius=10000&gscoord=\(latitude)|\(longitude)&gslimit=50&format=json"))
        
        return httpClient.perform(request).eraseToAnyPublisher()
    }
}
