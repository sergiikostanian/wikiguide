//
//  MapViewModel.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 29.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation
import UIKit.UIImage

/**
 Map screen ViewModel implementation.
 */
final class MapViewModel {
    
    weak var delegate: MapViewModelDelegate?
    
    // MARK: Dependencies
    private let dependencyManager: DependencyManager
    private let locationService: LocationService
    private let wikiService: WikiService

    // MARK: Completion Holders
    private var fetchUserLocationCompletion: ((Result<Location, Error>) -> Void)?
    
    init(dependencyManager: DependencyManager, locationService: LocationService, wikiService: WikiService) {
        self.dependencyManager = dependencyManager
        self.locationService = locationService
        self.wikiService = wikiService
        
        self.locationService.add(observer: self)
    }
    
    deinit {
        locationService.remove(observer: self)
    }
} 

// MARK: - MapViewModeling
extension MapViewModel: MapViewModeling {
    
    func fetchUserLocation(completion: @escaping (Result<Location, Error>) -> Void) {
        fetchUserLocationCompletion = completion
        
        switch locationService.authorizationStatus {
        case .authorized:
            locationService.requestLocation()
        case .notDetermined:
            locationService.requestWhenInUseAuthorization()
        case .denied:
            break
        }
    }
    
    func fetchWikiArticles(for location: Location, completion: @escaping (Result<[WikiArticle], Error>) -> Void) {
        wikiService.fetchArticles(latitude: location.latitude, longitude: location.longitude, completion: completion)
    }
    
    func fetchWikiArticleDetails(by id: Int, completion: @escaping (Result<WikiArticleDetails, Error>) -> Void) {
        wikiService.fetchArticleDetails(by: id, completion: completion)
    }
    
    func fetchImages(for articleDetails: WikiArticleDetails, completion: @escaping ([UIImage]) -> Void) {
        wikiService.fetchImages(by: articleDetails.imageFiles, completion: completion)
    }
    
    func openWikiArticleInSafari(_ article: WikiArticle) {
        guard let url = article.url else { return }
        UIApplication.shared.open(url)
    }

}

// MARK: - LocationServiceObserver
extension MapViewModel: LocationServiceObserver {

    func locationService(_ locationService: LocationService, didUpdateLatitude latitude: Double, longitude: Double) {
        fetchUserLocationCompletion?(.success((latitude: latitude, longitude: longitude)))
        fetchUserLocationCompletion = nil
        
        debugPrint("🌈 latitude: \(latitude), longitude: \(longitude)")
    }
    
    func locationService(_ locationService: LocationService, didChangeAuthorization status: LocationAuthorizationStatus) {
        if status == .authorized {
            locationService.requestLocation()
        }
    }
    
    func locationService(_ locationService: LocationService, didFailWithError error: Error) {
        fetchUserLocationCompletion?(.failure(error))
        fetchUserLocationCompletion = nil
        
        debugPrint(error)
    }
    
}
