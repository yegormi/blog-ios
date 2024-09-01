import Foundation

public protocol AuthUseCases {
    func login(email: String, password: String) async throws -> User
    func register(username: String, email: String, password: String) async throws -> User
    func logout() async throws
    func getCurrentUser() async throws -> User?
}
