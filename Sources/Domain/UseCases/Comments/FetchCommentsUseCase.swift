import Foundation

public protocol FetchCommentsUseCase {
    func execute(articleId: UUID) async throws -> [Comment]
}

public class FetchCommentsUseCaseImpl: FetchCommentsUseCase {
    private let commentRepository: CommentRepositoryProtocol

    public init(commentRepository: CommentRepositoryProtocol) {
        self.commentRepository = commentRepository
    }

    public func execute(articleId: UUID) async throws -> [Comment] {
        return try await self.commentRepository.getComments(for: articleId)
    }
}
