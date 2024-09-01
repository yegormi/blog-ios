import Domain
import SwiftUI

public struct ArticleListView: View {
    @EnvironmentObject var viewModel: ArticleListViewModel

    public init() {}

    public var body: some View {
        NavigationView {
            List(self.viewModel.articles) { article in
                NavigationLink(destination: ArticleDetailView(article: article)) {
                    ArticleRow(article: article)
                }
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
}
