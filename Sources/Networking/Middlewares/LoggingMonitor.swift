import Alamofire
import Foundation
import OSLog

class LoggingMonitor: EventMonitor {
    private let logger = Logger(subsystem: "APIClient", category: "Networking")

    func request(_: Request, didCreateURLRequest urlRequest: URLRequest) {
        self.logFullRequest(urlRequest)
    }

    func request(_ request: DataRequest, didParseResponse response: DataResponse<some Any, AFError>) {
        guard let httpResponse = response.response else { return }
        logFullResponse(httpResponse, request: response.request, data: response.data)
    }
}

extension LoggingMonitor {
    private func logFullRequest(_ request: URLRequest) {
        self.log(
            .header("🚀 Outgoing Request"),
            .keyValue("Method", request.method?.rawValue ?? "N/A"),
            .keyValue("URL", "\(request)"),
            .group("Headers", items: request.allHTTPHeaderFields?.map { .keyValue($0, $1) } ?? []),
            .group("Body", items: [.raw(request.httpBody?.prettyString ?? "None")])
        )
    }

    private func logFullResponse(_ response: HTTPURLResponse, request: URLRequest?, data: Data?) {
        self.log(
            .header("📥 Incoming Response"),
            .keyValue("Status Code", String(response.statusCode)),
            .keyValue("Method", request?.method?.rawValue ?? "N/A"),
            .keyValue("URL", response.url?.absoluteString ?? "N/A"),
            .group(
                "Headers",
                items: response.allHeaderFields.map {
                    .keyValue(String(describing: $0), String(describing: $1))
                }
            ),
            .group("Body", items: [.raw(data?.prettyString ?? "None")])
        )
    }

    private func log(_ items: LogItem...) {
        let message = items.map(\.description).joined(separator: "\n")
        self.logger.log("\(message)")
    }
}
