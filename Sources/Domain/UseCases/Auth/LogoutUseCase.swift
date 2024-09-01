import Foundation

public protocol LogoutUseCase {
    func execute() async throws
}

public class LogoutUseCaseImpl: LogoutUseCase {
    private let userRepository: UserRepositoryProtocol

    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    public func execute() async throws {
        try await self.userRepository.logout()
    }
}
