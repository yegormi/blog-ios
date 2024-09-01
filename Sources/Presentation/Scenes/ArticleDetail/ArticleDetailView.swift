import Domain
import SwiftUI

public struct ArticleDetailView: View {
    @StateObject var viewModel: ArticleDetailViewModel

    public init(article: Article) {
        _viewModel = StateObject(wrappedValue: ArticleDetailViewModel(article: article))
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(self.viewModel.article.content)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle(self.viewModel.article.title)
    }
}
