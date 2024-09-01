import Foundation
import Domain
import Networking

public class CommentRemoteDataSource {
    private let apiClient: APIClient

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    public func getComments(for articleId: UUID) async throws -> [CommentDTO] {
        return try await apiClient.request(.getComments(articleId: articleId))
    }

    public func createComment(content: String, articleId: UUID) async throws -> CommentDTO {
        return try await apiClient.request(.createComment(content: content, articleId: articleId))
    }

    public func deleteComment(id: UUID) async throws -> EmptyResponse {
        return try await apiClient.request(.deleteComment(id: id))
    }
}
