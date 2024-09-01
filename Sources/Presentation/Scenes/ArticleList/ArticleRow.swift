import SwiftUI
import Domain

public struct ArticleRow: View {
    let article: Article

    public var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .font(.headline)
            Text(article.content)
                .font(.subheadline)
                .lineLimit(2)
        }
    }
}
