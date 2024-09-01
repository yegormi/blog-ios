import Foundation
import Domain

public class ArticleListViewModel: ObservableObject {
    @Published public var articles: [Article] = []
    @Published public var showError = false
    @Published public var errorMessage = ""

    private let articleUseCase: ArticleUseCases

    public init(articleUseCase: ArticleUseCases) {
        self.articleUseCase = articleUseCase
    }

    public func fetchArticles() {
        Task {
            do {
                let fetchedArticles = try await articleUseCase.getArticles()
                await MainActor.run {
                    self.articles = fetchedArticles
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }
}
