import Alamofire
import Foundation

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
            .get
        case .createArticle, .login, .register, .createComment:
            .post
        case .updateArticle:
            .put
        case .deleteArticle, .logout, .deleteComment:
            .delete
        }
    }

    private var path: String {
        switch self {
        case .getArticles, .createArticle:
            "/articles"
        case let .getArticle(id), let .updateArticle(id, _, _), let .deleteArticle(id):
            "/articles/\(id)"
        case .getCurrentUser:
            "/auth/me"
        case .login:
            "/auth/login"
        case .register:
            "/auth/register"
        case .logout:
            "/auth/logout"
        case let .getComments(articleId), let .createComment(_, articleId):
            "/articles/\(articleId)/comments"
        case let .deleteComment(id):
            "/comments/\(id)"
        }
    }

    public func asURLRequest() throws -> URLRequest {
        let url = try APIRouter.baseURL.asURL().appendingPathComponent(self.path)
        var request = URLRequest(url: url)
        request.method = self.method

        switch self {
        case let .createArticle(title, content),
             let .updateArticle(_, title, content):
            request.httpBody = try JSONEncoder().encode(["title": title, "content": content])
        case let .login(email, password):
            request.httpBody = try JSONEncoder().encode(["email": email, "password": password])
        case let .register(username, email, password):
            request.httpBody = try JSONEncoder().encode(["username": username, "email": email, "password": password])
        case let .createComment(content, _):
            request.httpBody = try JSONEncoder().encode(["content": content])
        default:
            break
        }

        return request
    }

    private static let baseURL = "https://5cj816p8-8080.euw.devtunnels.ms"
}
