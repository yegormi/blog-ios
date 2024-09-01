import Domain
import Foundation
import Networking

public class CommentRemoteDataSource {
    private let apiClient: APIClient

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    public func getComments(for articleId: UUID) async throws -> [CommentDTO] {
        try await self.apiClient.request(.getComments(articleId: articleId))
    }

    public func createComment(content: String, articleId: UUID) async throws -> CommentDTO {
        try await self.apiClient.request(.createComment(content: content, articleId: articleId))
    }

    public func deleteComment(id: UUID) async throws -> EmptyResponse {
        try await self.apiClient.request(.deleteComment(id: id))
    }
}
