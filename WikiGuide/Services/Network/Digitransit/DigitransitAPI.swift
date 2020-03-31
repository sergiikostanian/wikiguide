//
//  DigitransitAPI.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 31.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

public class DigitransitAPI {
    
    private let baseURL = URL(string: "https://api.digitransit.fi/routing/v1/routers/hsl/index/graphql")!
    private let httpClient = HTTPClient()
    
}

extension DigitransitAPI: DigitransitService {
    
    public func fetchRouteSuggestion(from: Location, to: Location, completion: @escaping (Result<RouteSuggestion, Error>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyJSON: [String: Any] = [
            "query" : """
                {
                  plan(
                    from: {lat: \(from.latitude), lon: \(from.longitude)}
                    to: {lat: \(to.latitude), lon: \(to.longitude)}
                    numItineraries: 1
                  ) {
                    itineraries {
                      legs {
                        startTime
                        endTime
                        mode
                        duration
                        distance
                        route {
                          longName
                        }
                      }
                    }
                  }
                }
            """
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyJSON, options: .prettyPrinted)
        
        httpClient.perform(request) { (result: Result<APIModel.RouteSuggestionResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let itinerary = response.data.plan.itineraries.first else {
                        completion(.success(RouteSuggestion(segments: [])))
                        return
                    }
                    let routeSuggestion = APIModelMapper.makeRouteSuggestion(from: itinerary)
                    completion(.success(routeSuggestion))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
}
