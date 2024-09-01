import Domain
import SwiftUI

public struct ArticleRow: View {
    let article: Article

    public var body: some View {
        VStack(alignment: .leading) {
            Text(self.article.title)
                .font(.headline)
            Text(self.article.content)
                .font(.subheadline)
                .lineLimit(2)
        }
    }
}
