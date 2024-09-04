import Domain
import Foundation
import Networking

public final class UserRemoteDataSource {
    private let apiClient: APIClient
    private let sessionStorage: SessionStorageProtocol

    public init(apiClient: APIClient, sessionStorage: SessionStorageProtocol) {
        self.apiClient = apiClient
        self.sessionStorage = sessionStorage
    }

    public func login(email: String, password: String) async throws -> UserResponse {
        let body = LoginRequest(email: email, password: password)
        let response = try await apiClient.request(.login(body))

        try self.sessionStorage.setCurrentToken(response.token)
        self.sessionStorage.authenticate(response.user.toDomain())

        return response
    }

    public func register(username: String, email: String, password: String) async throws -> UserResponse {
        let body = RegisterRequest(username: username, email: email, password: password)
        let response = try await apiClient.request(.register(body))

        try self.sessionStorage.setCurrentToken(response.token)
        self.sessionStorage.authenticate(response.user.toDomain())

        return response
    }

    public func logout() async throws {
        _ = try await self.apiClient.request(.logout)
        try self.sessionStorage.logout()
    }

    public func getCurrentUser() async throws -> UserDTO {
        try await self.apiClient.request(.getCurrentUser)
    }

    public func uploadAvatar(imageData: Data, fileName: String) async throws -> UserDTO {
        try await self.apiClient.request(.uploadAvatar(imageData, fileName: fileName))
    }

    public func removeAvatar() async throws -> UserDTO {
        try await self.apiClient.request(.removeAvatar)
    }
}
