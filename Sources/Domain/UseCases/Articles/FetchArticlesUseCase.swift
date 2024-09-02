import Foundation

public protocol FetchArticlesUseCase {
    func execute() async throws -> [Article]
}

public final class FetchArticlesUseCaseImpl: FetchArticlesUseCase {
    private let articleRepository: ArticleRepositoryProtocol

    public init(articleRepository: ArticleRepositoryProtocol) {
        self.articleRepository = articleRepository
    }

    public func execute() async throws -> [Article] {
        try await self.articleRepository.getArticles()
    }
}
