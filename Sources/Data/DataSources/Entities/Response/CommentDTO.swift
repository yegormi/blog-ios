import Foundation

public struct CommentDTO: Decodable {
    public let id: UUID
    public let content: String
    public let articleId: UUID
    public let userId: UUID
//    public let createdAt: String
}
