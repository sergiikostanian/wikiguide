//
//  RouteSuggestionResponse.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 31.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

extension APIModel {
    
    struct RouteSuggestionResponse: Decodable {
        struct ResposeData: Decodable {
            struct Plan: Decodable {
                struct Itinerary: Decodable {
                    struct Leg: Decodable {
                        struct Route: Decodable {
                            let longName: String
                        }
                        let startTime: TimeInterval
                        let endTime: TimeInterval
                        let mode: String
                        let duration: TimeInterval
                        let distance: Double
                        let route: Route?
                    }
                    let legs: [Leg]
                }
                let itineraries: [Itinerary]
            }
            let plan: Plan
        }
        let data: ResposeData
    }
}
