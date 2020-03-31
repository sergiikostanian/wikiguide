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
import UIKit.UIImage
import Kingfisher

enum WikiError: Error {
    case fetchArticlesBadRequest
    case malformedResponse
}

public class WikiAPI {
    
    private let baseURL = URL(string: "https://en.wikipedia.org/w/api.php")!
    private let httpClient = HTTPClient()

    private let imageLoadingDispatchGroup = DispatchGroup()
    
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
            URLQueryItem(name: "gsradius", value: "10000"),
            URLQueryItem(name: "gscoord", value: "\(latitude)|\(longitude)"),
            URLQueryItem(name: "gslimit", value: "150"),
            URLQueryItem(name: "format", value: "json")
        ]
        
        guard let url = components.url else {
            completion(.failure(WikiError.fetchArticlesBadRequest))
            return
        }
        
        httpClient.perform(URLRequest(url: url)) { (result: Result<APIModel.WikiArticlesResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let articles = response.query.geosearch.map({ APIModelMapper.makeWikiArticle(from: $0) })
                    completion(.success(articles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func fetchArticleDetails(by id: Int, completion: @escaping (Result<WikiArticleDetails, Error>) -> Void) {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            completion(.failure(WikiError.fetchArticlesBadRequest))
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "prop", value: "info|description|images"),
            URLQueryItem(name: "pageids", value: "\(id)"),
            URLQueryItem(name: "format", value: "json")
        ]
        
        guard let url = components.url else {
            completion(.failure(WikiError.fetchArticlesBadRequest))
            return
        }
        
        httpClient.perform(URLRequest(url: url)) { (result: Result<APIModel.WikiArticleDetailsResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let apiModel = response.query.pages.values.first else {
                        completion(.failure(WikiError.malformedResponse))
                        return
                    }
                    let details = APIModelMapper.makeWikiArticleDetails(from: apiModel)
                    completion(.success(details))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func fetchImage(by file: String, completion: @escaping (UIImage?) -> Void) {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            completion(nil)
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "titles", value: "\(file)"),
            URLQueryItem(name: "prop", value: "imageinfo"),
            URLQueryItem(name: "iiprop", value: "url"),
            URLQueryItem(name: "iiurlwidth", value: "360"),
            URLQueryItem(name: "format", value: "json")
        ]
        
        guard let url = components.url else {
            completion(nil)
            return
        }
        
        httpClient.perform(URLRequest(url: url)) { (result: Result<APIModel.WikiImageResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let urlString = response.query.pages.values.first?.imageinfo.first?.thumburl,
                        let url = URL(string: urlString) else {
                        completion(nil)
                        return
                    }
                    
                    ImageDownloader.default.downloadImage(with: url) { imageResult in 
                        switch imageResult {
                        case .success(let value):
                            KingfisherManager.shared.cache.store(value.image, forKey: file)
                            completion(value.image)
                        case .failure:
                            completion(nil)
                        }
                    }
                case .failure:
                    completion(nil)
                }
            }
        }
    }
    
    public func fetchImages(by files: [String], completion: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        for file in files {
            imageLoadingDispatchGroup.enter()
            
            // Try get cached image. 
            if KingfisherManager.shared.cache.isCached(forKey: file) {
                KingfisherManager.shared.cache.retrieveImage(forKey: file) { imageResult in
                    if let image = try? imageResult.get().image {
                        images.append(image)
                    }
                    self.imageLoadingDispatchGroup.leave()
                }
                continue
            }
            
            // Fetch image if it's not cached.
            fetchImage(by: file) { [weak self] (image) in
                if let image = image {
                    images.append(image)
                }
                self?.imageLoadingDispatchGroup.leave()
            }
        }
        imageLoadingDispatchGroup.notify(queue: .main) { 
            completion(images)
        }
    }
}
