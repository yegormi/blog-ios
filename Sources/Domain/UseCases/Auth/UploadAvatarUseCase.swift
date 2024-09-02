import Foundation

public protocol UploadAvatarUseCase {
    func execute(imageData: Data, fileName: String) async throws -> User
}

public class UploadAvatarUseCaseImpl: UploadAvatarUseCase {
    private let userRepository: UserRepositoryProtocol

    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    public func execute(imageData: Data, fileName: String) async throws -> User {
        try await self.userRepository.uploadAvatar(imageData: imageData, fileName: fileName)
    }
}
