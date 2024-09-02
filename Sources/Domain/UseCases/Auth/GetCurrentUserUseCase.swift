import Foundation

public protocol GetCurrentUserUseCase {
    func execute() async throws -> User?
}

public final class GetCurrentUserUseCaseImpl: GetCurrentUserUseCase {
    private let userRepository: UserRepositoryProtocol

    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    public func execute() async throws -> User? {
        try await self.userRepository.getCurrentUser()
    }
}
