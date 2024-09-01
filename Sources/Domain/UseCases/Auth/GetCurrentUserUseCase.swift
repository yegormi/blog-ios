import Foundation

public protocol GetCurrentUserUseCase {
    func execute() async throws -> User?
}

public class GetCurrentUserUseCaseImpl: GetCurrentUserUseCase {
    private let userRepository: UserRepositoryProtocol

    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    public func execute() async throws -> User? {
        return try await self.userRepository.getCurrentUser()
    }
}
