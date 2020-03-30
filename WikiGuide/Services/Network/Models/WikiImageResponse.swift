//
//  WikiImageResponse.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 30.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

extension APIModel {
    
    struct WikiImageResponse: Decodable {
        struct Query: Decodable {
            struct Page: Decodable {
                struct ImageInfo: Decodable {
                    let url: String
                }
                let title: String
                let imageinfo: [ImageInfo]
            }
            let pages: [String: Page]
        }
        let batchcomplete: String
        let query: Query
    }
}
