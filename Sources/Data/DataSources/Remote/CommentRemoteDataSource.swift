import Domain
import Foundation
import Networking

public final class CommentRemoteDataSource {
    private let apiClient: APIClient

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    public func getComments(for articleId: UUID) async throws -> [CommentDTO] {
        try await self.apiClient.request(.getComments(articleId: articleId))
    }

    public func createComment(content: String, articleId: UUID) async throws -> CommentDTO {
        let request = CreateCommentRequest(content: content)
        return try await self.apiClient.request(.createComment(articleId: articleId, body: request))
    }

    public func deleteComment(id: UUID) async throws {
        _ = try await self.apiClient.request(.deleteComment(id: id))
    }
}
