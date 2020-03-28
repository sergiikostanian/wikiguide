//
//  WikiService.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

public protocol WikiService {
    
    func fetchArticles(latitude: Double, longitude: Double, completion: @escaping (Result<[APIModel.Article], Error>) -> Void)
    
}
