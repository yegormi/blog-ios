import Domain
import Foundation

public class CommentRepository: CommentRepositoryProtocol {
    private let remoteDataSource: CommentRemoteDataSource

    public init(remoteDataSource: CommentRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    public func getComments(for articleId: UUID) async throws -> [Comment] {
        try await self.remoteDataSource
            .getComments(for: articleId)
            .map { $0.toDomain() }
    }

    public func createComment(content: String, articleId: UUID) async throws -> Comment {
        try await self.remoteDataSource
            .createComment(content: content, articleId: articleId)
            .toDomain()
    }

    public func deleteComment(id: UUID) async throws {
        _ = try await self.remoteDataSource
            .deleteComment(id: id)
    }
}
