import Foundation

public protocol LoginUseCase {
    func execute(email: String, password: String) async throws -> User
}

public class LoginUseCaseImpl: LoginUseCase {
    private let userRepository: UserRepositoryProtocol

    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    public func execute(email: String, password: String) async throws -> User {
        return try await self.userRepository.login(email: email, password: password)
    }
}
