import Foundation

public protocol GetArticleUseCase {
    func execute(id: UUID) async throws -> Article
}

public class GetArticleUseCaseImpl: GetArticleUseCase {
    private let articleRepository: ArticleRepositoryProtocol

    public init(articleRepository: ArticleRepositoryProtocol) {
        self.articleRepository = articleRepository
    }

    public func execute(id: UUID) async throws -> Article {
        try await self.articleRepository.getArticle(id: id)
    }
}
