import Foundation

public struct APIConfiguration {
    public static let shared = APIConfiguration()
    public let baseURL: URL

    private init() {
        self.baseURL = URL(string: "http://127.0.0.1:8080")!
    }
}
