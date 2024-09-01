import Foundation

public protocol CreateCommentUseCase {
    func execute(content: String, articleId: UUID) async throws -> Comment
}

public class CreateCommentUseCaseImpl: CreateCommentUseCase {
    private let commentRepository: CommentRepositoryProtocol

    public init(commentRepository: CommentRepositoryProtocol) {
        self.commentRepository = commentRepository
    }

    public func execute(content: String, articleId: UUID) async throws -> Comment {
        try await self.commentRepository.createComment(content: content, articleId: articleId)
    }
}
