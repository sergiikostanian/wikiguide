//
//  MapVC.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

enum MapScreenState {
    case main
    case articleDetails
    case routeSuggestions
}

final class MapVC: UIViewController {

    private var stateSwitcher: MapScreenStateSwitcher! 
    private var state: MapScreenState?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateSwitcher = MapScreenStateSwitcher(mapVC: self)
        setState(.main)
    }

    func setState(_ state: MapScreenState, animated: Bool = true) {
        stateSwitcher.performTransition(from: self.state, to: state, animated: animated)
        self.state = state
    }

}

