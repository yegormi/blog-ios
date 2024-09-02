import Foundation

public protocol APIRequestModel: Encodable {}

public struct CreateArticleRequest: APIRequestModel {
    let title: String
    let content: String

    public init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}

public struct UpdateArticleRequest: APIRequestModel {
    let title: String
    let content: String

    public init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}

public struct LoginRequest: APIRequestModel {
    let email: String
    let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct RegisterRequest: APIRequestModel {
    let username: String
    let email: String
    let password: String

    public init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
}

public struct CreateCommentRequest: APIRequestModel {
    let content: String

    public init(content: String) {
        self.content = content
    }
}
