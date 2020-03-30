//
//  WikiArticle.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 29.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

public struct WikiArticle {
    let pageId: Int
    let title: String
    let latitude: Double
    let longitude: Double
    
    var url: URL? {
        let path = title.replacingOccurrences(of: " ", with: "_")
        return URL(string: "https://en.wikipedia.org/wiki/\(path)")
    }
}
