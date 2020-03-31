//
//  DigitransitService.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 31.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

/**
 This service provides data from Digitransit available via public API.
 For more detail see [Digitransit API](https://digitransit.fi/en/developers/apis).
 */
public protocol DigitransitService {
    
    typealias Location = (latitude: Double, longitude: Double)

    func fetchRouteSuggestion(from: Location, to: Location, completion: @escaping (Result<RouteSuggestion, Error>) -> Void)
    
}
