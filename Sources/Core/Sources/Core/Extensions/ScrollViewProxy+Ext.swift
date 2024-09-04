//
//  ScrollViewProxy+Ext.swift
//  Spendbase
//
//  Created by Larik on 20.06.2024.
//

import SwiftUI

extension ScrollViewProxy {
    /// this constant is needed for delay before keyboard appears on the screen, ensuring proper work of scrollTo function
    static let KeyboardAppearOnScrollDelay: UInt64 = 300_000_000
}
