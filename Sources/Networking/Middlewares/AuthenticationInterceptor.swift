import Alamofire
import Foundation

public protocol SessionProvider {
    func getCurrentToken() throws -> String?
    func logout() throws
}

final class AuthenticationInterceptor: RequestInterceptor {
    private let session: SessionProvider

    public init(session: SessionProvider) {
        self.session = session
    }

    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) throws {
        var urlRequest = urlRequest
        if let token = try self.session.getCurrentToken() {
            urlRequest.headers.add(.authorization(bearerToken: token))
        }
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for _: Session, dueTo _: Error, completion: @escaping (RetryResult) -> Void) throws {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            // Token might be expired, delete it
            try self.session.logout()
            completion(.doNotRetry)
        } else {
            completion(.doNotRetry)
        }
    }
}
