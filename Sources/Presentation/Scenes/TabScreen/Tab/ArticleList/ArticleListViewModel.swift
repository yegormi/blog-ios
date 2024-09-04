import Domain
import Foundation
import os

private let logger = Logger(subsystem: "ArticleListViewModel", category: "Presentation")

@MainActor
public final class ArticleListViewModel: ObservableObject {
    @Published public var articles: [Article] = []

    private let fetchArticlesUseCase: FetchArticlesUseCase

    public init(fetchArticlesUseCase: FetchArticlesUseCase) {
        self.fetchArticlesUseCase = fetchArticlesUseCase
    }

    public func fetchArticles() async {
        do {
            self.articles = try await self.fetchArticlesUseCase.execute()
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
}
