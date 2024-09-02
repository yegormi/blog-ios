import Foundation

public protocol FetchCommentsUseCase {
    func execute(articleId: UUID) async throws -> [Comment]
}

public final class FetchCommentsUseCaseImpl: FetchCommentsUseCase {
    private let commentRepository: CommentRepositoryProtocol

    public init(commentRepository: CommentRepositoryProtocol) {
        self.commentRepository = commentRepository
    }

    public func execute(articleId: UUID) async throws -> [Comment] {
        try await self.commentRepository.getComments(for: articleId)
    }
}
