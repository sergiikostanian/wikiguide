//
//  MapNavigationMode.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 30.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation
import MapKit

final class MapNavigationMode: MapMode {
    
    var context = MapModeContext()
    
    private weak var mapVC: MapVC?
    private weak var mapView: MKMapView?

    func performTransition(from: MapMode?, animated: Bool) {
        
    }
    
}
