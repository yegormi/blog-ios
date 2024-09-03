import Domain
import Foundation

public final class UserRepository: UserRepositoryProtocol {
    private let remoteDataSource: UserRemoteDataSource

    public init(remoteDataSource: UserRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    public func login(email: String, password: String) async throws -> User {
        try await self.remoteDataSource
            .login(email: email, password: password)
            .user
            .toDomain()
    }

    public func register(username: String, email: String, password: String) async throws -> User {
        try await self.remoteDataSource
            .register(username: username, email: email, password: password)
            .user
            .toDomain()
    }

    public func logout() async throws {
        try await self.remoteDataSource.logout()
    }

    public func getCurrentUser() async throws -> User {
        try await self.remoteDataSource
            .getCurrentUser()
            .toDomain()
    }

    public func uploadAvatar(imageData: Data, fileName: String) async throws -> User {
        try await self.remoteDataSource
            .uploadAvatar(imageData: imageData, fileName: fileName)
            .toDomain()
    }

    public func removeAvatar() async throws -> User {
        try await self.remoteDataSource
            .removeAvatar()
            .toDomain()
    }
}
