import Foundation
import Domain

public class ArticleRepository: ArticleUseCases {
    private let remoteDataSource: ArticleRemoteDataSource

    public init(remoteDataSource: ArticleRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    public func getArticles() async throws -> [Article] {
        return try await remoteDataSource
            .getArticles()
            .map { $0.toDomain() }
    }

    public func getArticle(id: UUID) async throws -> Article {
        return try await remoteDataSource
            .getArticle(id: id)
            .toDomain()
    }

    public func createArticle(title: String, content: String) async throws -> Article {
        return try await remoteDataSource
            .createArticle(title: title, content: content)
            .toDomain()
    }

    public func updateArticle(id: UUID, title: String, content: String) async throws -> Article {
        return try await remoteDataSource
            .updateArticle(id: id, title: title, content: content)
            .toDomain()
    }

    public func deleteArticle(id: UUID) async throws {
        _ = try await remoteDataSource
            .deleteArticle(id: id)
    }
}
