import Foundation
import Domain

// MARK: - ArticleDTO Extensions

extension ArticleDTO {
    func toDomain() -> Article {
        return Article(
            id: self.id,
            title: self.title,
            content: self.content,
            userId: self.userId
        )
    }
}

extension Article {
    func toDTO() -> ArticleDTO {
        return ArticleDTO(
            id: self.id,
            title: self.title,
            content: self.content,
            userId: self.userId
        )
    }
}

// MARK: - UserDTO Extensions

extension UserDTO {
    func toDomain() -> User {
        return User(
            id: self.id,
            username: self.username,
            email: self.email,
            avatarUrl: URL(string: self.avatarUrl ?? "")
        )
    }
}

extension User {
    func toDTO() -> UserDTO {
        return UserDTO(
            id: self.id,
            username: self.username,
            email: self.email,
            avatarUrl: self.avatarUrl?.absoluteString
        )
    }
}

// MARK: - CommentDTO Extensions

extension CommentDTO {
    func toDomain() -> Comment {
        return Comment(
            id: self.id,
            content: self.content,
            articleId: self.articleId,
            userId: self.userId
        )
    }
}

extension Comment {
    func toDTO() -> CommentDTO {
        return CommentDTO(
            id: self.id,
            content: self.content,
            articleId: self.articleId,
            userId: self.userId
        )
    }
}
