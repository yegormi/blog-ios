import Foundation

public struct ArticleDTO: Decodable {
    public let id: UUID
    public let title: String
    public let content: String
    public let userId: UUID

    public init(id: UUID, title: String, content: String, userId: UUID) {
        self.id = id
        self.title = title
        self.content = content
        self.userId = userId
    }
}
