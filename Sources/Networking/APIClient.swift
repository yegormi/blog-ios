import Alamofire
import Foundation
import OSLog

private let logger = Logger(subsystem: "APIClient", category: "Networking")

public class APIClient {
    private let baseURL: URL
    private let session: Session
    private let decoder: JSONDecoder
    private let tokenManager: TokenManager

    public init(baseURL: URL) {
        self.baseURL = baseURL
        self.tokenManager = TokenManager()
        let interceptor = AuthenticationInterceptor(tokenManager: tokenManager)
        self.session = Session(interceptor: interceptor)
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            return try ISO8601DateTranscoder().decode(dateString)
        }
    }

    public func request<T: Decodable>(_ route: APIRouter) async throws -> T {
        var urlRequest = try route.asURLRequest()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.logFullRequest(urlRequest)

        return try await withCheckedThrowingContinuation { continuation in
            self.session.request(urlRequest)
                .validate()
                .responseData { [weak self] response in
                    guard let self else { return }

                    self.logFullResponse(response.response, data: response.data)

                    switch response.result {
                    case let .success(data):
                        do {
                            let decodedResponse = try self.decoder.decode(T.self, from: data)
                            continuation.resume(returning: decodedResponse)
                        } catch {
                            continuation.resume(throwing: APIError.invalidResponse)
                        }
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    private func logFullRequest(_ request: URLRequest) {
        self.log(
            .header("🚀 Outgoing Request"),
            .keyValue("URL", request.url?.absoluteString ?? "N/A"),
            .keyValue("Method", request.httpMethod ?? "N/A"),
            .group("Headers", items: request.allHTTPHeaderFields?.map { .keyValue($0, $1) } ?? []),
            .group("Body", items: [.raw(request.httpBody?.prettyString ?? "None")])
        )
    }

    private func logFullResponse(_ response: HTTPURLResponse?, data: Data?) {
        self.log(
            .header("📥 Incoming Response"),
            .keyValue("URL", response?.url?.absoluteString ?? "N/A"),
            .keyValue("Status Code", String(response?.statusCode ?? 0)),
            .group(
                "Headers",
                items: response?.allHeaderFields.map { .keyValue(String(describing: $0), String(describing: $1)) } ?? []
            ),
            .group("Body", items: [.raw(data?.prettyString ?? "None")])
        )
    }

    private func log(_ items: LogItem...) {
        let message = items.map(\.description).joined(separator: "\n")
        logger.log("\(message)")
    }
}

// MARK: - Logging Helpers

enum LogItem {
    case header(String)
    case keyValue(String, String)
    case group(String, items: [LogItem])
    case raw(String)

    var description: String {
        switch self {
        case let .header(text):
            return "\n=== \(text) ===\n"
        case let .keyValue(key, value):
            return "\(key): \(value)"
        case let .group(title, items):
            let content = items.map(\.description).joined(separator: "\n").indented()
            return "\(title):\n\(content)"
        case let .raw(text):
            return text
        }
    }
}

extension String {
    func indented(by spaces: Int = 4) -> String {
        let indent = String(repeating: " ", count: spaces)
        return components(separatedBy: .newlines)
            .map { indent + $0 }
            .joined(separator: "\n")
    }
}

extension Data {
    var prettyString: String {
        guard
            let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyString = String(data: data, encoding: .utf8)
        else {
            return String(data: self, encoding: .utf8) ?? "Unable to parse JSON"
        }
        return prettyString
    }
}
