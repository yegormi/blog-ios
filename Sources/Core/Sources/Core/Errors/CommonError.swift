//
//  CommonError.swift
//  Spendbase
//
//  Created by Larik on 07.12.2023.
//

import Foundation

/// Representation of common errors
public enum CommonError: LocalizedError {
    case guardError(String)

    /// Error description
    var localizedDescription: String {
        switch self {
        case .guardError(let message):
            message
        }
    }
}
