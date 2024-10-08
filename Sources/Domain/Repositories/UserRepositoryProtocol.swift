import Foundation

public protocol UserRepositoryProtocol {
    func login(email: String, password: String) async throws -> User
    func register(username: String, email: String, password: String) async throws -> User
    func logout() async throws
    func getCurrentUser() async throws -> User
    func uploadAvatar(imageData: Data, fileName: String) async throws -> User
    func removeAvatar() async throws -> User
}
