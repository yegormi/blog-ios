import Foundation

public protocol DeleteArticleUseCase {
    func execute(id: UUID) async throws
}

public final class DeleteArticleUseCaseImpl: DeleteArticleUseCase {
    private let articleRepository: ArticleRepositoryProtocol

    public init(articleRepository: ArticleRepositoryProtocol) {
        self.articleRepository = articleRepository
    }

    public func execute(id: UUID) async throws {
        try await self.articleRepository.deleteArticle(id: id)
    }
}
