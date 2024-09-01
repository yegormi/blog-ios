import Foundation

public struct UserDTO: Decodable {
    public let id: UUID
    public let username: String
    public let email: String
    public let avatarUrl: String?
}
