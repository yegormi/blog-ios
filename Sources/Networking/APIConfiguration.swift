import Foundation

public struct APIConfiguration {
    public static let shared = APIConfiguration()
    public let baseURL: String

    private init() {
        self.baseURL = "http://127.0.0.1:8080"
    }
}
