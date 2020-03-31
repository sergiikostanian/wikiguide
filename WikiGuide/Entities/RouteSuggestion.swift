//
//  RouteSuggestion.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 31.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

/// Suggested route info.
public struct RouteSuggestion {
    
    /// The mode of the route segment.
    public enum Mode: String {
        case bicycle = "BICYCLE"
        case bus = "BUS"
        case cableCar = "CABLE_CAR"
        case car = "CAR"
        case ferry = "FERRY"
        case funicular = "FUNICULAR"
        case gondola = "GONDOLA"
        case rail = "RAIL"
        case subway = "SUBWAY"
        case tram = "TRAM"
        case transit = "TRANSIT"
        case walk = "WALK"
    }

    /// One unit of the route.
    public struct Segment {
        let startTime: TimeInterval
        let endTime: TimeInterval
        let mode: Mode
        let duration: TimeInterval
        let distance: Double
        let details: String?
    }
    
    let segments: [Segment]
}
