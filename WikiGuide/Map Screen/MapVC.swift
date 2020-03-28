//
//  MapVC.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit
import MapKit

enum MapScreenState {
    case main
    case articleDetails
    case routeSuggestions
}

final class MapVC: UIViewController {

    private var dependencyManager: DependencyManager!
    private var locationService: LocationService!
    private var wikiService: WikiService!
    private var stateSwitcher: MapScreenStateSwitcher!
    
    private var state: MapScreenState?
    
    @IBOutlet private weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateSwitcher = MapScreenStateSwitcher(mapVC: self)
        setState(.main)
        
        mapView.setUserTrackingMode(.follow, animated: true)

        locationService.add(observer: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch locationService.authorizationStatus {
        case .authorized:
            locationService.requestLocation()
        case .notDetermined:
            locationService.requestWhenInUseAuthorization()
        case .denied:
            break
        }
    }

    deinit {
        locationService.remove(observer: self)
    }
    
    func setState(_ state: MapScreenState, animated: Bool = true) {
        stateSwitcher.performTransition(from: self.state, to: state, animated: animated)
        self.state = state
    }

}

extension MapVC: DependencyInjectable {
    
    func setupDependencies(with dependencyManager: DependencyManager) {
        self.dependencyManager = dependencyManager
        locationService = try! dependencyManager.resolve() as LocationService
        wikiService = try! dependencyManager.resolve() as WikiService
    }
    
}

extension MapVC: LocationServiceObserver {

    func locationService(_ locationService: LocationService, didUpdateLatitude latitude: Double, longitude: Double) {
        wikiService.fetchArticles(latitude: latitude, longitude: longitude) { (result) in
            debugPrint(result)
        }
        debugPrint("🌈 latitude: \(latitude), longitude: \(longitude)")
    }
    
    func locationService(_ locationService: LocationService, didChangeAuthorization status: LocationAuthorizationStatus) {
        if status == .authorized {
            locationService.requestLocation()
        }
    }
    
    func locationService(_ locationService: LocationService, didFailWithError error: Error) {
        debugPrint(error)
    }
    
}
