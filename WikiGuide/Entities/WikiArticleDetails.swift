//
//  WikiArticleDetails.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 30.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

public struct WikiArticleDetails {
    let pageId: Int
    let title: String
    let description: String
    let imageFiles: [String]
    
    var url: URL? {
        let path = title.replacingOccurrences(of: " ", with: "_")
        return URL(string: "https://en.wikipedia.org/wiki/\(path)")
    }
}
