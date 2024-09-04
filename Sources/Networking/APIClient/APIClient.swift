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
        let request: DataRequest = if let multipartFormData = route.multipartFormData {
            self.session.upload(multipartFormData: multipartFormData, with: route)
        } else {
            self.session.request(route)
        }

        let result = await request
            .serializingData(emptyResponseCodes: [204, 205])
            .result

        switch result {
        case let .success(data):
            if data.isEmpty {
                if let emptyInstance = Empty.emptyValue() as? T {
                    return emptyInstance
                } else {
                    throw APIError.unexpectedEmptyResponse
                }
            }

            if let serverError = try? self.decoder.decode(ServerError.self, from: data) {
                throw APIError.serverError(serverError)
            }

            return try self.decoder.decode(T.self, from: data)

        case let .failure(error):
            throw APIError.from(error)
        }
    }
}
