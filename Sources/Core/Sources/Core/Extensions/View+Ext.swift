//
//  View+Ext.swift
//  Spendbase
//
//  Created by Larik on 12.01.2024.
//

import SwiftUI

extension ScrollViewProxy: @unchecked Sendable {}

extension View {
    @ViewBuilder
    func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }

    func scrollTo(with id: String, _ value: ScrollViewProxy) {
        Task {
            let keyboardAppearOnScrollDelay: UInt64 = 300_000_000
            try? await Task.sleep(nanoseconds: keyboardAppearOnScrollDelay)
            withAnimation {
                value.scrollTo(id, anchor: .bottom)
            }
        }
    }
}
