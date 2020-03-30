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
 and calls completion block with a result.
 */
struct HTTPClient {
    
    private let urlSession = URLSession.shared
    
    /// This method performs a specified `URLRequest`.
    /// 
    /// - Parameters:
    ///   - request: `URLRequest` to perform.
    ///   - decoder: Decoder to decode result data into a `Value` type instance. Default is `JSONDecoder`.
    ///   - completion: Request completion block.
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
}
