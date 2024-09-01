import Foundation

public struct ArticleDTO: Decodable {
    public let id: UUID
    public let title: String
    public let content: String
    public let userId: UUID
//    public let createdAt: String
//    public let updatedAt: String
}
