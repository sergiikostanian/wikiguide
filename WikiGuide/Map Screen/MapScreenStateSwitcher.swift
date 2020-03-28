//
//  MapScreenStateSwitcher.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

struct MapScreenStateSwitcher {
    
    private weak var mapVC: MapVC?
    
    init(mapVC: MapVC) {
        self.mapVC = mapVC
    }
    
    /// Describes transition between states.
    func performTransition(from: MapScreenState?, to: MapScreenState, animated: Bool) {
        switch (from, to) {
        case (nil, .main):
            break
        case (.main, .articleDetails):
            break
        case (.articleDetails, .main):
            break
        default:
            break
        }
    }

}
