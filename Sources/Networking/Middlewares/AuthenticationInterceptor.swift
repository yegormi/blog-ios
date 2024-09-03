import Alamofire
import Foundation

public protocol SessionInterceptor {
    func getCurrentToken() throws -> String?
    func logout() throws
}

public class AuthenticationInterceptor: RequestInterceptor {
    private let sessionInterceptor: SessionInterceptor

    init(sessionInterceptor: SessionInterceptor) {
        self.sessionInterceptor = sessionInterceptor
    }

    public func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest

        do {
            if let token = try sessionInterceptor.getCurrentToken() {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            completion(.success(urlRequest))
        } catch {
            completion(.failure(error))
        }
    }

    public func retry(_ request: Request, for _: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            do {
                try self.sessionInterceptor.logout()
                completion(.doNotRetry)
            } catch {
                completion(.doNotRetryWithError(error))
            }
        } else {
            completion(.doNotRetry)
        }
    }
}
