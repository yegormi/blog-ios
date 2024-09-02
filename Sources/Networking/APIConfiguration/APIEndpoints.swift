import Alamofire
import Foundation

public extension APIRoute {
    static func request<T: Decodable>(_ method: HTTPMethod, _ path: RequestPath, _ body: RequestBody? = nil) -> APIRoute<T> {
        let pathString: String
        let requestBody: APIRequestBody?

        switch path {
        case let .path(p):
            pathString = p
        }

        switch body {
        case let .body(b):
            requestBody = b
        case .none:
            requestBody = nil
        }

        return APIRoute<T>(method: method, path: pathString, body: requestBody)
    }

    static var getArticles: APIRoute<[ArticleDTO]> {
        self.request(.get, .path("articles"))
    }

    static func getArticle(id: UUID) -> APIRoute<ArticleDTO> {
        self.request(.get, .path("articles/\(id)"))
    }

    static func createArticle(_ body: CreateArticleRequest) -> APIRoute<ArticleDTO> {
        self.request(.post, .path("articles"), .body(body))
    }

    static func updateArticle(id: UUID, body: UpdateArticleRequest) -> APIRoute<ArticleDTO> {
        self.request(.put, .path("articles/\(id)"), .body(body))
    }

    static func deleteArticle(id: UUID) -> APIRoute<EmptyResponse> {
        self.request(.delete, .path("articles/\(id)"))
    }

    static func login(_ body: LoginRequest) -> APIRoute<UserResponse> {
        self.request(.post, .path("auth/login"), .body(body))
    }

    static func register(_ body: RegisterRequest) -> APIRoute<UserResponse> {
        self.request(.post, .path("auth/register"), .body(body))
    }

    static var logout: APIRoute<EmptyResponse> {
        self.request(.post, .path("me/logout"))
    }

    static var getCurrentUser: APIRoute<UserDTO> {
        self.request(.get, .path("me"))
    }

    static func uploadAvatar(_ image: Data, fileName: String) -> APIRoute<UserDTO> {
        self.multipartRequest(.post, "me/avatar/upload") { formData in
            formData.append(image, withName: "file", fileName: fileName, mimeType: "image/jpeg")
        }
    }

    static var removeAvatar: APIRoute<UserDTO> {
        request(.delete, .path("me/avatar/remove"))
    }

    static func getComments(articleId: UUID) -> APIRoute<[CommentDTO]> {
        self.request(.get, .path("articles/\(articleId)/comments"))
    }

    static func createComment(articleId: UUID, body: CreateCommentRequest) -> APIRoute<CommentDTO> {
        self.request(.post, .path("articles/\(articleId)/comments"), .body(body))
    }

    static func deleteComment(id: UUID) -> APIRoute<EmptyResponse> {
        self.request(.delete, .path("comments/\(id)"))
    }
}
