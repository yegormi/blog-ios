import Foundation

public protocol UpdateArticleUseCase {
    func execute(id: UUID, title: String, content: String) async throws -> Article
}

public class UpdateArticleUseCaseImpl: UpdateArticleUseCase {
    private let articleRepository: ArticleRepositoryProtocol

    public init(articleRepository: ArticleRepositoryProtocol) {
        self.articleRepository = articleRepository
    }

    public func execute(id: UUID, title: String, content: String) async throws -> Article {
        return try await self.articleRepository.updateArticle(id: id, title: title, content: content)
    }
}
