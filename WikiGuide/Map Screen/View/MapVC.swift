//
//  MapVC.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit
import MapKit

enum MapState {
    case main
    case articleDetails
    case navigation
}

final class MapVC: UIViewController, AlertableViewController {

    // MARK: Dependencies
    private var dependencyManager: DependencyManager!
    private var viewModel: MapViewModeling!
    
    // MARK: State Properties
    private var state: MapState?
    private var mode: MapMode?

    // MARK: View Properties
    @IBOutlet private weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setState(.main)
    }
    
    func setState(_ state: MapState, animated: Bool = true) {
        guard self.state != state else { return }
        
        let newMode: MapMode
        
        switch state {
        case .main:
            newMode = MapMainMode(mapVC: self, mapView: mapView, mapViewModel: viewModel)
        case .articleDetails:
            newMode = MapArticleDetailsMode(mapVC: self, mapView: mapView, mapViewModel: viewModel)
        case .navigation:
            newMode = MapNavigationMode()
        }
        
        newMode.context = mode?.context ?? .init()
        newMode.performTransition(from: mode, animated: animated)
        mode = newMode
        self.state = state
    }
}

// MARK: - DependencyInjectable
extension MapVC: DependencyInjectable {
    
    func setupDependencies(with dependencyManager: DependencyManager) {
        self.dependencyManager = dependencyManager
        viewModel = try! dependencyManager.resolve() as MapViewModeling
    }
}
