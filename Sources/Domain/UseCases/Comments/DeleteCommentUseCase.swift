import Foundation

public protocol DeleteCommentUseCase {
    func execute(id: UUID) async throws
}

public final class DeleteCommentUseCaseImpl: DeleteCommentUseCase {
    private let commentRepository: CommentRepositoryProtocol

    public init(commentRepository: CommentRepositoryProtocol) {
        self.commentRepository = commentRepository
    }

    public func execute(id: UUID) async throws {
        try await self.commentRepository.deleteComment(id: id)
    }
}
