import Alamofire
import Foundation
import OSLog

private let logger = Logger(subsystem: "APIClient", category: "Networking")

public final class APIClient {
    private let session: Session
    private let decoder: JSONDecoder

    public init(sessionProvider: SessionInterceptor) {
        let interceptor = AuthenticationInterceptor(sessionInterceptor: sessionProvider)
        let logger = LoggingMonitor()

        self.session = Session(interceptor: interceptor, eventMonitors: [logger])
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .custom(ISO8601DateTranscoder().decode)
    }

    public func request<T: Decodable>(_ route: APIRoute<T>) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            let request: DataRequest = if let multipartFormData = route.multipartFormData {
                self.session.upload(multipartFormData: multipartFormData, with: route)
            } else {
                self.session.request(route)
            }

            request
                .validate()
                .responseDecodable(
                    of: T.self,
                    decoder: self.decoder,
                    emptyResponseCodes: [204, 205]
                ) { response in
                    switch response.result {
                    case let .success(value):
                        continuation.resume(returning: value)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
