import Foundation
import Networking

public class ArticleRemoteDataSource {
    private let apiClient: APIClient

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    public func getArticles() async throws -> [ArticleDTO] {
        return try await apiClient.request(APIRouter.getArticles)
    }

    public func getArticle(id: UUID) async throws -> ArticleDTO {
        return try await apiClient.request(APIRouter.getArticle(id: id))
    }

    public func createArticle(title: String, content: String) async throws -> ArticleDTO {
        return try await apiClient.request(APIRouter.createArticle(title: title, content: content))
    }

    public func updateArticle(id: UUID, title: String, content: String) async throws -> ArticleDTO {
        return try await apiClient.request(APIRouter.updateArticle(id: id, title: title, content: content))
    }

    public func deleteArticle(id: UUID) async throws -> EmptyResponse {
        return try await apiClient.request(APIRouter.deleteArticle(id: id))
    }
}
