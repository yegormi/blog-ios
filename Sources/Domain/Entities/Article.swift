import Foundation

public struct Article: Identifiable {
    public let id: UUID
    public let title: String
    public let content: String
    public let userId: UUID
//    public let createdAt: Date
//    public let updatedAt: Date

    public init(
        id: UUID,
        title: String,
        content: String,
        userId: UUID
//        createdAt: Date,
//        updatedAt: Date
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.userId = userId
//        self.createdAt = createdAt
//        self.updatedAt = updatedAt
    }
}
