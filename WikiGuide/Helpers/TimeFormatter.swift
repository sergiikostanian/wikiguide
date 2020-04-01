//
//  TimeFormatter.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 31.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

extension Formatter {
    
    /// A simple `DateFormatter` that represents time in format  __"H:mm"__.
    /// Example string representation: 17:45.
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        return formatter
    }()
    
}
