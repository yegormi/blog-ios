import Domain
import Foundation

@MainActor
public final class ArticleListViewModel: ObservableObject {
    @Published public var articles: [Article] = []
    @Published public var showError = false
    @Published public var errorMessage = ""

    private let fetchArticlesUseCase: FetchArticlesUseCase

    public init(fetchArticlesUseCase: FetchArticlesUseCase) {
        self.fetchArticlesUseCase = fetchArticlesUseCase
    }

    public func fetchArticles() async {
        do {
            self.articles = try await self.fetchArticlesUseCase.execute()
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
}
