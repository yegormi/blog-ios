import Foundation

public struct LoginRequest: APIRequestBody {
    let email: String
    let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
