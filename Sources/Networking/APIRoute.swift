import Alamofire
import Foundation

public struct APIRoute<ResponseType: Decodable>: URLRequestConvertible {
    private let method: HTTPMethod
    private let path: String
    private let body: APIRequestBody?

    init(method: HTTPMethod, path: String, body: APIRequestBody? = nil) {
        self.method = method
        self.path = path
        self.body = body
    }

    public func asURLRequest() throws -> URLRequest {
        let url = try APIConfiguration.shared.baseURL.asURL().appendingPathComponent(self.path)
        var request = URLRequest(url: url)
        request.method = self.method
        request.headers.add(.accept("application/json"))

        if let body = self.body {
            request.httpBody = try JSONEncoder().encode(body)
            request.headers.add(.contentType("application/json"))
        }

        return request
    }
}
