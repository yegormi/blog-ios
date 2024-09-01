import SwiftUI
import Domain

public struct ArticleDetailView: View {
    @StateObject var viewModel: ArticleDetailViewModel

    public init(article: Article) {
        _viewModel = StateObject(wrappedValue: ArticleDetailViewModel(article: article))
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.article.title)
                    .font(.title)
                Text(viewModel.article.content)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Article")
    }
}
