import DIContainer
import Domain
import SwiftUI

public struct ArticleListView: View {
    @StateObject var viewModel: ArticleListViewModel
    @State private var showingCreateArticle = false
    private let makeViewModel: (Article) -> ArticleDetailViewModel
    private let makeCreateArticleViewModel: () -> CreateArticleViewModel
    private let container: DIContainer

    public init(
        viewModel: ArticleListViewModel,
        container: DIContainer,
        makeViewModel: @escaping (Article) -> ArticleDetailViewModel,
        makeCreateArticleViewModel: @escaping () -> CreateArticleViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.container = container
        self.makeViewModel = makeViewModel
        self.makeCreateArticleViewModel = makeCreateArticleViewModel
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.showingCreateArticle = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: self.$showingCreateArticle) {
            CreateArticleView(viewModel: self.makeCreateArticleViewModel()) {
                Task { await self.viewModel.fetchArticles() }
                self.showingCreateArticle = false
            }
        }
        .task {
            await self.viewModel.fetchArticles()
        }
        .refreshable {
            await self.viewModel.fetchArticles()
        }
    }
}
