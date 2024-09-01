import Domain
import Foundation
import Networking

public class UserRemoteDataSource {
    private let apiClient: APIClient
    private let tokenManager: TokenManager

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
        self.tokenManager = TokenManager()
    }

    public func login(email: String, password: String) async throws -> UserResponse {
        let response: UserResponse = try await apiClient.request(.login(email: email, password: password))
        self.tokenManager.saveToken(response.token)
        return response
    }

    public func register(username: String, email: String, password: String) async throws -> UserResponse {
        let response: UserResponse = try await apiClient.request(.register(username: username, email: email, password: password))
        self.tokenManager.saveToken(response.token)
        return response
    }

    public func logout() async throws -> EmptyResponse {
        let response: EmptyResponse = try await apiClient.request(.logout)
        self.tokenManager.deleteToken()
        return response
    }

    public func getCurrentUser() async throws -> UserDTO? {
        try await self.apiClient.request(.getCurrentUser)
    }
}
