//
//  UIViewController+Ext.swift
//  Spendbase
//
//  Created by Larik on 28.06.2024.
//

import UIKit

extension UIViewController {
    /// Get root view controller
    @MainActor
    static func getRootViewController() throws -> UIViewController {
        // Receive window
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first

        // Receive root view controller
        guard let rootViewController = window?.rootViewController else {
            throw CommonError.guardError("Unavailable root view controller")
        }
        return rootViewController
    }
}
