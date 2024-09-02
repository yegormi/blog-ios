import Domain
import Foundation
import Networking

public final class UserRemoteDataSource {
    private let apiClient: APIClient
    private let tokenManager: TokenManager

    public init(apiClient: APIClient, tokenManager: TokenManager) {
        self.apiClient = apiClient
        self.tokenManager = tokenManager
    }

    public func login(email: String, password: String) async throws -> UserResponse {
        let body = LoginRequest(email: email, password: password)
        let response = try await apiClient.request(.login(body))
        self.tokenManager.saveToken(response.token)
        return response
    }

    public func register(username: String, email: String, password: String) async throws -> UserResponse {
        let body = RegisterRequest(username: username, email: email, password: password)
        let response = try await apiClient.request(.register(body))
        self.tokenManager.saveToken(response.token)
        return response
    }

    public func logout() async throws -> EmptyResponse {
        let response = try await apiClient.request(.logout)
        self.tokenManager.deleteToken()
        return response
    }

    public func getCurrentUser() async throws -> UserDTO? {
        try await self.apiClient.request(.getCurrentUser)
    }

    public func uploadAvatar(imageData: Data, fileName: String) async throws -> UserDTO {
        try await self.apiClient.request(.uploadAvatar(imageData, fileName: fileName))
    }

    public func removeAvatar() async throws -> UserDTO {
        try await self.apiClient.request(.removeAvatar)
    }
}
