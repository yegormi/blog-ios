import Foundation

public struct Comment: Identifiable {
    public let id: UUID
    public let content: String
    public let articleId: UUID
    public let userId: UUID
//    public let createdAt: Date

    public init(
        id: UUID,
        content: String,
        articleId: UUID,
        userId: UUID
//        createdAt: Date
    ) {
        self.id = id
        self.content = content
        self.articleId = articleId
        self.userId = userId
//        self.createdAt = createdAt
    }
}
