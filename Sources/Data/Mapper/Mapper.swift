import Domain
import Foundation
import Networking

// MARK: - ArticleDTO Extensions

extension ArticleDTO {
    func toDomain() -> Article {
        Article(
            id: id,
            title: title,
            content: content,
            userId: userId
        )
    }
}

extension Article {
    func toDTO() -> ArticleDTO {
        ArticleDTO(
            id: id,
            title: title,
            content: content,
            userId: userId
        )
    }
}

// MARK: - UserDTO Extensions

extension UserDTO {
    func toDomain() -> User {
        User(
            id: id,
            username: username,
            email: email,
            avatarUrl: URL(string: avatarUrl ?? "")
        )
    }
}

extension User {
    func toDTO() -> UserDTO {
        UserDTO(
            id: id,
            username: username,
            email: email,
            avatarUrl: avatarUrl?.absoluteString
        )
    }
}

// MARK: - CommentDTO Extensions

extension CommentDTO {
    func toDomain() -> Comment {
        Comment(id: self.id, content: self.content, user: self.user.toDomain(), createdAt: self.createdAt)
    }
}

extension Comment {
    func toDTO() -> CommentDTO {
        CommentDTO(id: self.id, content: self.content, user: self.user.toDTO(), createdAt: self.createdAt)
    }
}
