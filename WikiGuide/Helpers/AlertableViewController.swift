//
//  AlertableViewController.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 29.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

/**
 This is a `UIViewController` protocol extension that provides ability to display simple alerts by one method call.
 */
public protocol AlertableViewController {
    func showError(_ error: Error, handler: (() -> Void)?)
    func showMessage(_ message: String, handler: (() -> Void)?)
}

extension AlertableViewController where Self: UIViewController {
    
    /// Presents an alert with the given error `localizedDescription` and an `OK` button.
    /// 
    /// - Parameters:
    ///   - error: An error to display.
    ///   - handler: Handler block that will be called on `OK` button tap.
    public func showError(_ error: Error, handler: (() -> Void)? = nil) {
        showMessage(error.localizedDescription, handler: handler)
    }

    /// Presents an alert with the given message string and an `OK` button.
    /// 
    /// - Parameters:
    ///   - message: A message to display.
    ///   - handler: Handler block that will be called on `OK` button tap.
    public func showMessage(_ message: String, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)        
        let action = UIAlertAction(title: "OK", style: .cancel) { _ in
            handler?()
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
}
