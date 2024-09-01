import Domain
import Foundation

@MainActor
public class ArticleListViewModel: ObservableObject {
    @Published public var articles: [Article] = []
    @Published public var showError = false
    @Published public var errorMessage = ""

    private let articleUseCase: ArticleUseCases

    public init(articleUseCase: ArticleUseCases) {
        self.articleUseCase = articleUseCase
    }

    public func fetchArticles() async {
        do {
            self.articles = try await self.articleUseCase.getArticles()
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
}
