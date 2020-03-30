//
//  MapMode.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 30.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation
import MapKit

protocol MapMode: AnyObject {
    
    /// MapMode context.
    /// 
    /// - Note: `MapVC` automatically set context to mode by fetching it from an old mode.
    var context: MapModeContext { get set }

    /// Describes transition between states.
    func performTransition(from oldMode: MapMode?, animated: Bool)
    
}

/// Made to simplify data flows between modes.
struct MapModeContext {
    var selectedAnnotation: WikiArticleAnnotation?
    var originalMapRect: MKMapRect?
}
