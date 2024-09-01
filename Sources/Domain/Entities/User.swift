import Foundation

public struct User: Identifiable {
    public let id: UUID
    public let username: String
    public let email: String
    public let avatarUrl: URL?

    public init(id: UUID, username: String, email: String, avatarUrl: URL?) {
        self.id = id
        self.username = username
        self.email = email
        self.avatarUrl = avatarUrl
    }
}
