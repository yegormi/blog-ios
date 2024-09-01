import Foundation
import Domain

public class CommentRepository: CommentUseCases {
    private let remoteDataSource: CommentRemoteDataSource

    public init(remoteDataSource: CommentRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    public func getComments(for articleId: UUID) async throws -> [Comment] {
        return try await remoteDataSource
            .getComments(for: articleId)
            .map { $0.toDomain() }
    }

    public func createComment(content: String, articleId: UUID) async throws -> Comment {
        return try await remoteDataSource
            .createComment(content: content, articleId: articleId)
            .toDomain()
    }

    public func deleteComment(id: UUID) async throws {
        _ = try await remoteDataSource
            .deleteComment(id: id)
    }
}
