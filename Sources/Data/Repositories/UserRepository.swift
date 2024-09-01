import Foundation
import Domain

public class UserRepository: AuthUseCases {
    private let remoteDataSource: UserRemoteDataSource

    public init(remoteDataSource: UserRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    public func login(email: String, password: String) async throws -> User {
        return try await remoteDataSource
            .login(email: email, password: password)
            .user
            .toDomain()
    }

    public func register(username: String, email: String, password: String) async throws -> User {
        return try await remoteDataSource
            .register(username: username, email: email, password: password)
            .user
            .toDomain()
    }

    public func logout() async throws {
        _ = try await remoteDataSource.logout()
    }

    public func getCurrentUser() async throws -> User? {
        return try await remoteDataSource
            .getCurrentUser()?
            .toDomain()
    }
}
