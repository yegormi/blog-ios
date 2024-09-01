import Domain
import Foundation

public class ArticleRepository: ArticleUseCases {
    private let remoteDataSource: ArticleRemoteDataSource

    public init(remoteDataSource: ArticleRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    public func getArticles() async throws -> [Article] {
        try await self.remoteDataSource
            .getArticles()
            .map { $0.toDomain() }
    }

    public func getArticle(id: UUID) async throws -> Article {
        try await self.remoteDataSource
            .getArticle(id: id)
            .toDomain()
    }

    public func createArticle(title: String, content: String) async throws -> Article {
        try await self.remoteDataSource
            .createArticle(title: title, content: content)
            .toDomain()
    }

    public func updateArticle(id: UUID, title: String, content: String) async throws -> Article {
        try await self.remoteDataSource
            .updateArticle(id: id, title: title, content: content)
            .toDomain()
    }

    public func deleteArticle(id: UUID) async throws {
        _ = try await self.remoteDataSource
            .deleteArticle(id: id)
    }
}
