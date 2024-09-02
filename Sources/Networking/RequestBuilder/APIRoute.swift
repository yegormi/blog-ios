import Alamofire
import Foundation

public struct APIRoute<ResponseType: Decodable>: URLRequestConvertible {
    private let method: HTTPMethod
    private let path: String
    private let body: APIRequestBody?

    let multipartFormData: MultipartFormData?

    init(
        method: HTTPMethod,
        path: String,
        body: APIRequestBody? = nil,
        multipartFormData: MultipartFormData? = nil
    ) {
        self.method = method
        self.path = path
        self.body = body
        self.multipartFormData = multipartFormData
    }

    public func asURLRequest() throws -> URLRequest {
        let url = try APIConfiguration.shared.baseURL.asURL().appendingPathComponent(self.path)
        var request = URLRequest(url: url)
        request.method = self.method
        request.headers.add(.accept("application/json"))

        if let body = self.body {
            request.headers.add(.contentType("application/json"))
            request.httpBody = try JSONEncoder().encode(body)
        } else if let _ = self.multipartFormData {
            request.headers.add(.contentType("multipart/form-data"))
        }

        return request
    }
}

extension APIRoute {
    static func multipartRequest<T: Decodable>(
        _ method: HTTPMethod,
        _ path: String,
        multipartFormData: @escaping (MultipartFormData) -> Void
    ) -> APIRoute<T> {
        let formData = MultipartFormData()
        multipartFormData(formData)
        return APIRoute<T>(method: method, path: path, multipartFormData: formData)
    }
}
