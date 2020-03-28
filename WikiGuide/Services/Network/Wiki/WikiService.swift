//
//  WikiService.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

public protocol WikiService {
    
    func fetchArticles(for coordinate: CLLocationCoordinate2D, completion: @escaping (Result<[APIModel.Article], Error>) -> Void)
    
}
