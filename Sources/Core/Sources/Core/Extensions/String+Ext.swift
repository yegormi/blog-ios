//
//  String+Ext.swift
//  Spendbase
//
//  Created by Larik on 22.11.2023.
//

import Foundation

extension NumberFormatter {
    static var currencyInput: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.maximumFractionDigits = 2
        formatter.generatesDecimalNumbers = true
        return formatter
    }
}

extension String {
    /// Capitalizes string value
    var capitalizedSentence: String {
        var first: String
        var remaining: String
        var final: [String] = []
        
        let sentences = self.components(separatedBy: ". ")
        
        for sentence in sentences {
            first = sentence.prefix(1).capitalized
            remaining = sentence.dropFirst().lowercased()
            final.append(first + remaining)
        }
        return final.joined(separator: ". ")
    }
    
    /// Remove extra spaces
    var compactWhitespace: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    var localized: LocalizedStringResource {
        LocalizedStringResource(stringLiteral: self)
    }
    
    func toErrorCode() -> SBErrorCode? {
        guard let match = self.firstMatch(of: Regex.errorSBRegex),
              let errorNumber = Int(match.1) else {
            return nil
        }
        return SBErrorCode(rawValue: errorNumber)
    }
}

// MARK: - Regex validation

extension Regex where Output == Substring {
    static var emailValidationRegex: Regex {
        /[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/
    }
    
    static var passwordValidationRegex: Regex {
        /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,}$/
    }
    
    static var specialCharactersRegex: Regex {
        /(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?])/
    }
        
    static var ibanInputRegex: Regex<(Substring, Substring, Substring)> {
        /^([A-Z]{0,2}[0-9]{0,2})([A-Z0-9]{0,30})$/
    }
    
    static var ibanValidationRegex: Regex<(Substring, Substring, Substring)> {
        /^([A-Z]{2}[0-9]{2})([A-Z0-9]{12,30})$/
    }
    
    static var authCodeInputRegex: Regex {
        /^[0-9]{0,6}$/
    }
    
    static var authCodeValidationRegex: Regex {
        /^[0-9]{6}$/
    }
    
    static var phoneValidationRegex: Regex {
        /^\d{9,10}$/
    }
    
    static var errorSBRegex: Regex<(Substring, Substring)> {
        /SBERR-(\d+)/
    }
    
    static var cardNumberGroupedByFourMax: Regex<(Substring, Substring)> {
        /(\d{4})/
    }
}
