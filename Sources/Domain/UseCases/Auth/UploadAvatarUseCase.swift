import Foundation
import UIKit

public protocol UploadAvatarUseCase {
    func execute(image: UIImage, fileName: String) async throws -> User
}

public class UploadAvatarUseCaseImpl: UploadAvatarUseCase {
    private let userRepository: UserRepositoryProtocol

    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    public func execute(image: UIImage, fileName: String) async throws -> User {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw EncodingError.invalidValue(image, EncodingError.Context(
                codingPath: [],
                debugDescription: "Failed to convert UIImage to JPEG Data"
            ))
        }
        return try await self.userRepository
            .uploadAvatar(imageData: imageData, fileName: fileName)
    }
}
