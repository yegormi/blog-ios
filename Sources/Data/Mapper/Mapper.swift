import Domain
import Foundation

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
        Comment(
            id: id,
            content: content,
            articleId: articleId,
            userId: userId
        )
    }
}

extension Comment {
    func toDTO() -> CommentDTO {
        CommentDTO(
            id: id,
            content: content,
            articleId: articleId,
            userId: userId
        )
    }
}
