import Foundation

public protocol CommentRepositoryProtocol {
    func getComments(for articleId: UUID) async throws -> [Comment]
    func createComment(content: String, articleId: UUID) async throws -> Comment
    func deleteComment(id: UUID) async throws
}
