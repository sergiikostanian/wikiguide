//
//  DependencyInjectable.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

/**
 A type that requires dependencies injection. 
 */
public protocol DependencyInjectable {
    /// Implement this method to resolve all required dependencies using `dependencyManager`.
    func setupDependencies(with dependencyManager: DependencyManager)
}
