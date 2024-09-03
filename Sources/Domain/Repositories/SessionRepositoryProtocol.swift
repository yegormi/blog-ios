import Foundation

public protocol SessionRepositoryProtocol {
    func authenticate(user: User)
    func setToken(_ token: String) throws
    func getToken() throws -> String?
    func getCurrentUser() -> User?
    func observeCurrentUser() -> AsyncStream<User?>
    func logout() throws
}
