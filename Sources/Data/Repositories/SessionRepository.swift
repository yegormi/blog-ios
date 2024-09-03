import Combine
import Domain
import Foundation

public final class SessionRepository: SessionRepositoryProtocol {
    private let sessionStorage: SessionStorageProtocol

    public init(sessionStorage: SessionStorageProtocol) {
        self.sessionStorage = sessionStorage
    }

    public func authenticate(user: User) {
        self.sessionStorage.authenticate(user)
    }

    public func setToken(_ token: String) throws {
        try self.sessionStorage.setCurrentToken(token)
    }

    public func getToken() throws -> String? {
        try self.sessionStorage.getCurrentToken()
    }

    public func getCurrentUser() -> User? {
        self.sessionStorage.getCurrentUser()
    }

    public func observeCurrentUser() -> AsyncStream<User?> {
        self.sessionStorage.getCurrentUsers()
    }

    public func logout() throws {
        try self.sessionStorage.logout()
    }
}
