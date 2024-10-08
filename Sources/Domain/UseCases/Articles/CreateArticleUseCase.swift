import Foundation

public protocol CreateArticleUseCase {
    func execute(title: String, content: String) async throws -> Article
}

public final class CreateArticleUseCaseImpl: CreateArticleUseCase {
    private let articleRepository: ArticleRepositoryProtocol

    public init(articleRepository: ArticleRepositoryProtocol) {
        self.articleRepository = articleRepository
    }

    public func execute(title: String, content: String) async throws -> Article {
        try await self.articleRepository.createArticle(title: title, content: content)
    }
}
