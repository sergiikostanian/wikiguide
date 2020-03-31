//
//  TimeFormatter.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 31.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

extension Formatter {
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        return formatter
    }()
    
}
