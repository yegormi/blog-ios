import Foundation

public protocol RegisterUseCase {
    func execute(username: String, email: String, password: String) async throws -> User
}

public class RegisterUseCaseImpl: RegisterUseCase {
    private let userRepository: UserRepositoryProtocol

    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    public func execute(username: String, email: String, password: String) async throws -> User {
        return try await self.userRepository.register(username: username, email: email, password: password)
    }
}
