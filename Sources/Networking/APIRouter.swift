import Foundation
import Alamofire

public enum APIRouter: URLRequestConvertible {
    case getArticles
    case getArticle(id: UUID)
    case createArticle(title: String, content: String)
    case updateArticle(id: UUID, title: String, content: String)
    case deleteArticle(id: UUID)
    case login(email: String, password: String)
    case register(username: String, email: String, password: String)
    case getCurrentUser
    case logout
    case getComments(articleId: UUID)
    case createComment(content: String, articleId: UUID)
    case deleteComment(id: UUID)

    private var method: HTTPMethod {
        switch self {
        case .getArticles, .getArticle, .getComments, .getCurrentUser:
            return .get
        case .createArticle, .login, .register, .createComment:
            return .post
        case .updateArticle:
            return .put
        case .deleteArticle, .logout, .deleteComment:
            return .delete
        }
    }

    private var path: String {
        switch self {
        case .getArticles, .createArticle:
            return "/articles"
        case .getArticle(let id), .updateArticle(let id, _, _), .deleteArticle(let id):
            return "/articles/\(id)"
        case .getCurrentUser:
            return "/auth/me"
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .logout:
            return "/auth/logout"
        case .getComments(let articleId), .createComment(_, let articleId):
            return "/articles/\(articleId)/comments"
        case .deleteComment(let id):
            return "/comments/\(id)"
        }
    }

    public func asURLRequest() throws -> URLRequest {
        let url = try APIRouter.baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method

        switch self {
        case .createArticle(let title, let content),
             .updateArticle(_, let title, let content):
            request.httpBody = try JSONEncoder().encode(["title": title, "content": content])
        case .login(let email, let password):
            request.httpBody = try JSONEncoder().encode(["email": email, "password": password])
        case .register(let username, let email, let password):
            request.httpBody = try JSONEncoder().encode(["username": username, "email": email, "password": password])
        case .createComment(let content, _):
            request.httpBody = try JSONEncoder().encode(["content": content])
        default:
            break
        }

        return request
    }

    private static let baseURL: String = "https://5cj816p8-8080.euw.devtunnels.ms"
}
