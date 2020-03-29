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

final class MapVC: UIViewController, AlertableViewController {

    private var dependencyManager: DependencyManager!
    private(set) var viewModel: MapViewModeling!
    
    private var stateSwitcher: MapScreenStateSwitcher!
    private var state: MapScreenState?
    
    @IBOutlet private weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        stateSwitcher = MapScreenStateSwitcher(mapVC: self)
        mapView.delegate = self
    }
    
    func setState(_ state: MapScreenState, animated: Bool = true) {
        stateSwitcher.performTransition(from: self.state, to: state, animated: animated)
        self.state = state
    }
}

extension MapVC {
    
    func centerMap(latitude: Double, longitude: Double, radius: CLLocationDistance, animated: Bool) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: radius * 2.0, longitudinalMeters: radius * 2.0)
        mapView.setRegion(region, animated: animated)
    }

    func displayArticlesAnnotations(_ annotations: [WikiArticleAnnotation]) {
        let oldArticlesAnnotations = mapView.annotations.filter({ $0 is WikiArticleAnnotation })
        mapView.removeAnnotations(oldArticlesAnnotations)
        mapView.showAnnotations(annotations, animated: true)
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        setState(.main)
    }
    
}

extension MapVC: DependencyInjectable {
    
    func setupDependencies(with dependencyManager: DependencyManager) {
        self.dependencyManager = dependencyManager
        viewModel = try! dependencyManager.resolve() as MapViewModeling
    }
}
