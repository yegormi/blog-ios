import Foundation

public protocol RemoveAvatarUseCase {
    func execute() async throws -> User
}

public final class RemoveAvatarUseCaseImpl: RemoveAvatarUseCase {
    private let userRepository: UserRepositoryProtocol

    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    public func execute() async throws -> User {
        try await self.userRepository.removeAvatar()
    }
}
