import Foundation

public struct RegisterRequest: APIRequestBody {
    let username: String
    let email: String
    let password: String

    public init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
}
