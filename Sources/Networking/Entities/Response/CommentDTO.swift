import Foundation

public struct CommentDTO: Decodable {
    public let id: UUID
    public let content: String
    public let user: UserDTO
    public let createdAt: Date

    public init(id: UUID, content: String, user: UserDTO, createdAt: Date) {
        self.id = id
        self.content = content
        self.user = user
        self.createdAt = createdAt
    }
}
