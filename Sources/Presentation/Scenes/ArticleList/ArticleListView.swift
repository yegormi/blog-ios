import Domain
import SwiftUI

public struct ArticleListView: View {
    @ObservedObject var viewModel: ArticleListViewModel
    private let makeViewModel: (Article) -> ArticleDetailViewModel

    public init(
        viewModel: ArticleListViewModel,
        makeViewModel: @escaping (Article) -> ArticleDetailViewModel
    ) {
        self.viewModel = viewModel
        self.makeViewModel = makeViewModel
    }

    public var body: some View {
        List(self.viewModel.articles) { article in
            NavigationLink(destination: ArticleDetailView(
                viewModel: self.makeViewModel(article)
            )) {
                ArticleRow(article: article)
            }
        }
        .refreshable {
            await self.viewModel.fetchArticles()
        }
        .navigationTitle("Articles")
        .onAppear {
            Task { await self.viewModel.fetchArticles() }
        }
        .alert("Error", isPresented: self.$viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(self.viewModel.errorMessage)
        }
    }
}
