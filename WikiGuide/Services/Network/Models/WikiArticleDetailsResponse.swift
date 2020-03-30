//
//  WikiArticleDetailsResponse.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 30.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

extension APIModel {
    
    struct WikiArticleDetailsResponse: Decodable {
        struct Query: Decodable {
            struct ArticleDetails: Decodable {
                struct Image: Decodable {
                    let ns: Int
                    let title: String
                }
                let pageid: Int
                let title: String
                let description: String
                let images: [Image]
            }
            let pages: [String: ArticleDetails]
        }
        let batchcomplete: String
        let query: Query
    }
}
