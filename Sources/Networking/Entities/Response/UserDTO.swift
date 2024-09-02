import Foundation

public struct UserDTO: Decodable {
    public let id: UUID
    public let username: String
    public let email: String
    public let avatarUrl: String?

    public init(
        id: UUID,
        username: String,
        email: String,
        avatarUrl: String? = nil
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.avatarUrl = avatarUrl
    }
}
