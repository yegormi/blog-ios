import Foundation

public struct CommentDTO: Decodable {
    public let id: UUID
    public let content: String
    public let articleId: UUID
    public let userId: UUID

    public init(id: UUID, content: String, articleId: UUID, userId: UUID) {
        self.id = id
        self.content = content
        self.articleId = articleId
        self.userId = userId
    }
}
