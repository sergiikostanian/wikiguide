//
//  HTTPClient.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation
import Combine

/**
 The HTTP client that performs a specified `URLRequest`, 
 transforms received result data into a Decodable value 
 and returns `AnyPublisher` object. 
 */
struct HTTPClient {
    
    private let urlSession = URLSession.shared
    
    /// This method performs a specified `URLRequest`.
    /// 
    /// - Parameters:
    ///   - request: `URLRequest` to perform.
    ///   - decoder: Decoder to decode result data into a `Value` type instance. Default is `JSONDecoder`.
    func perform<Value: Decodable>(_ request: URLRequest, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<Value, Error>) -> Void) {
        urlSession.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let value = try decoder.decode(Value.self, from: data) 
                    completion(.success(value))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    /// The assignments requirement clearly states that the app must run in native iOS 12
    /// and unfortunately `Combine` framework is available only from iOS 13, but anyway 
    /// I decided to implement example method that uses Combine to show how would I do this 
    /// if deployment target will be iOS 13.
    @available(iOS 13.0, *)
    func perform<Value: Decodable>(_ request: URLRequest, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Value, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Value in
                let value = try decoder.decode(Value.self, from: result.data)
                return value
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
