import SwiftUI
import Domain

public struct ArticleListView: View {
    @EnvironmentObject var viewModel: ArticleListViewModel

    public init() {}

    public var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
                NavigationLink(destination: ArticleDetailView(article: article)) {
                    ArticleRow(article: article)
                }
            }
            .navigationTitle("Articles")
            .onAppear {
                viewModel.fetchArticles()
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}
