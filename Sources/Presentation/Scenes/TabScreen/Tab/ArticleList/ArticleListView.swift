import DIContainer
import Domain
import SwiftUI

public struct ArticleListView: View {
    @StateObject var viewModel: ArticleListViewModel
    private let makeViewModel: (Article) -> ArticleDetailViewModel
    private let container: DIContainer

    public init(
        viewModel: ArticleListViewModel,
        container: DIContainer,
        makeViewModel: @escaping (Article) -> ArticleDetailViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.container = container
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
        .navigationTitle("Articles")
        .task {
            await self.viewModel.fetchArticles()
        }
        .refreshable {
            await self.viewModel.fetchArticles()
        }
        .alert("Error", isPresented: self.$viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(self.viewModel.errorMessage)
        }
    }
}
