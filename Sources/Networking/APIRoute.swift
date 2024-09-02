import Alamofire
import Foundation

public struct APIConfiguration {
    public static let shared = APIConfiguration()
    public let baseURL: String

    private init() {
        self.baseURL = "http://127.0.0.1:8080"
    }
}

public struct APIRoute<ResponseType: Decodable>: URLRequestConvertible {
    private let path: String
    private let method: HTTPMethod
    private let requestModel: APIRequestModel?

    init(path: String, method: HTTPMethod, requestModel: APIRequestModel? = nil) {
        self.path = path
        self.method = method
        self.requestModel = requestModel
    }

    public func asURLRequest() throws -> URLRequest {
        let url = try APIConfiguration.shared.baseURL.asURL().appendingPathComponent(self.path)
        var request = URLRequest(url: url)
        request.method = self.method

        if let model = self.requestModel {
            request.httpBody = try JSONEncoder().encode(model)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}
