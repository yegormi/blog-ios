import SwiftUI

public struct SplashView: View {
    public init() {}

    public var body: some View {
        Text("YeBlog")
            .font(.system(size: 200, weight: .bold, design: .rounded))
            .minimumScaleFactor(0.0001)
            .lineLimit(1)
            .padding(48)
    }
}
