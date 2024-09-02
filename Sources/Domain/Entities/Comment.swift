import Foundation

public struct Comment: Identifiable {
    public let id: UUID
    public let content: String
    public let user: User
    public let createdAt: Date

    public init(id: UUID, content: String, user: User, createdAt: Date) {
        self.id = id
        self.content = content
        self.user = user
        self.createdAt = createdAt
    }
}
