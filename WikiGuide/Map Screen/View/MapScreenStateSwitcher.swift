//
//  MapScreenStateSwitcher.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

final class MapScreenStateSwitcher {
    
    private weak var mapVC: MapVC?
    
    init(mapVC: MapVC) {
        self.mapVC = mapVC
    }
    
    /// Describes transition between states.
    func performTransition(from: MapScreenState?, to: MapScreenState, animated: Bool) {
        switch (from, to) {
        case (nil, .main):
            initialSetup()
        case (.main, .articleDetails):
            break
        case (.articleDetails, .main):
            break
        default:
            break
        }
    }

    private func initialSetup() {
        guard let mapVC = mapVC else { return }
        guard let viewModel = mapVC.viewModel else { return }

        // Fetch user location.
        viewModel.fetchUserLocation { (result) in
            switch result {
                
            case .success(let location):
                mapVC.centerMap(latitude: location.latitude, longitude: location.longitude, radius: 5000, animated: false)
                
                // Fetch and display nearby wiki articles. 
                viewModel.fetchWikiArticles(for: location, completion: { (result) in
                    switch result {
                        
                    case .success(let articles):
                        debugPrint("⛺️ articles: \(articles.count)")
                        mapVC.displayArticlesAnnotations(articles.map({ WikiArticleAnnotation(article: $0) }))
                        
                    case .failure(let error):
                        mapVC.showError(error)
                    }
                })
                
            case .failure(let error):
                mapVC.showError(error)
            }
        }
    }
    
}

