//
//  WikiArticlesResponse.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

extension APIModel {
    
    struct WikiArticlesResponse: Decodable {
        struct Query: Decodable {
            struct Article: Decodable {
                let pageid: Int
                let title: String
                let lat: Double
                let lon: Double
            }
            let geosearch: [Article]
        }
        let batchcomplete: String
        let query: Query
    }
}
