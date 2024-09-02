import Foundation
import Networking

public class ArticleRemoteDataSource {
    private let apiClient: APIClient

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    public func getArticles() async throws -> [ArticleDTO] {
        try await self.apiClient.request(.getArticles)
    }

    public func getArticle(id: UUID) async throws -> ArticleDTO {
        try await self.apiClient.request(.getArticle(id: id))
    }

    public func createArticle(title: String, content: String) async throws -> ArticleDTO {
        let body = CreateArticleRequest(title: title, content: content)
        return try await self.apiClient.request(.createArticle(body))
    }

    public func updateArticle(id: UUID, title: String, content: String) async throws -> ArticleDTO {
        let body = UpdateArticleRequest(title: title, content: content)
        return try await self.apiClient.request(.updateArticle(id: id, body: body))
    }

    public func deleteArticle(id: UUID) async throws -> EmptyResponse {
        try await self.apiClient.request(.deleteArticle(id: id))
    }
}
