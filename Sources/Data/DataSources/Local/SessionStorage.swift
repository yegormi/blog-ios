import Combine
import ConcurrencyExtras
import Domain
import Foundation

public protocol SessionStorageProtocol {
    func authenticate(_ user: User)
    func setCurrentToken(_ token: String) throws
    func getCurrentToken() throws -> String?
    func getCurrentUser() -> User?
    func getCurrentUsers() -> AsyncStream<User?>
    func logout() throws
}

public final class SessionStorage: SessionStorageProtocol {
    private let keychain: KeychainStorage

    private let storage = LockIsolated(Storage())
    private let subject = PassthroughSubject<User?, Never>()

    struct Storage {
        var currentUser: User?
        var currentAuthenticationToken: String?
    }

    public init(keychain: KeychainStorage) {
        self.keychain = keychain
    }

    public func authenticate(_ user: User) {
        self.storage.withValue { $0.currentUser = user }
        self.subject.send(user)
    }

    public func setCurrentToken(_ token: String) throws {
        self.storage.withValue { $0.currentAuthenticationToken = token }
        try self.keychain.save(token, forKey: .authenticationToken)
    }

    public func getCurrentToken() throws -> String? {
        guard let token = storage.value.currentAuthenticationToken else {
            let savedToken: String? = try keychain.getString(forKey: .authenticationToken)
            if let savedToken {
                self.storage.withValue { $0.currentAuthenticationToken = savedToken }
            }
            return savedToken
        }

        return token
    }

    public func getCurrentUser() -> User? {
        self.storage.value.currentUser
    }

    public func getCurrentUsers() -> AsyncStream<User?> {
        self.subject.values.eraseToStream()
    }

    public func logout() throws {
        self.storage.withValue {
            $0.currentAuthenticationToken = nil
            $0.currentUser = nil
        }
        self.subject.send(nil)
        try self.keychain.delete(forKey: .authenticationToken)
    }
}
