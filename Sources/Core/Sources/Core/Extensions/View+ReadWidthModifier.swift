//
//  View+ReadWidthModifier.swift
//  Spendbase
//
//  Created by Yehor Myropoltsev on 24.07.2024.
//

import SwiftUI

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat(0)
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ReadWidthModifier: ViewModifier {
    @Binding var width: CGFloat

    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: WidthPreferenceKey.self, value: proxy.size.width)
            }
        }
        .onPreferenceChange(WidthPreferenceKey.self) { value in
            DispatchQueue.main.async {
                self.width = value
            }
        }
    }
}

extension View {
    func readWidth(onChange: @escaping (CGFloat) -> Void) -> some View {
        self.modifier(ReadWidthModifier(width: .init(get: { 0 }, set: onChange)))
    }
}
