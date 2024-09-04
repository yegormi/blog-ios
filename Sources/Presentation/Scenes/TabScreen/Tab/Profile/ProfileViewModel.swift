import Domain
import Foundation
import SwiftUI

@MainActor
public final class ProfileViewModel: ObservableObject {
    @Published public var user: User?
    @Published public var isLoading = false
    @Published public var errorMessage: String?

    private let getCurrentUserUseCase: GetCurrentUserUseCase
    private let uploadAvatarUseCase: UploadAvatarUseCase
    private let removeAvatarUseCase: RemoveAvatarUseCase
    private let logoutUseCase: LogoutUseCase

    public init(
        getCurrentUserUseCase: GetCurrentUserUseCase,
        uploadAvatarUseCase: UploadAvatarUseCase,
        removeAvatarUseCase: RemoveAvatarUseCase,
        logoutUseCase: LogoutUseCase
    ) {
        self.getCurrentUserUseCase = getCurrentUserUseCase
        self.uploadAvatarUseCase = uploadAvatarUseCase
        self.removeAvatarUseCase = removeAvatarUseCase
        self.logoutUseCase = logoutUseCase
    }

    public func fetchProfile() async {
        self.isLoading = true
        do {
            self.user = try await self.getCurrentUserUseCase.execute()
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to fetch profile: \(error.localizedDescription)"
            self.isLoading = false
        }
    }

    public func uploadAvatar(_ image: UIImage) async {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            self.errorMessage = "Failed to process image"
            return
        }

        self.isLoading = true
        do {
            self.user = try await self.uploadAvatarUseCase.execute(
                imageData: imageData,
                fileName: "\(UUID().uuidString.lowercased()).jpg"
            )
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to upload avatar: \(error.localizedDescription)"
            self.isLoading = false
        }
    }

    public func removeAvatar() async {
        self.isLoading = true
        do {
            self.user = try await self.removeAvatarUseCase.execute()
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to remove avatar: \(error.localizedDescription)"
            self.isLoading = false
        }
    }

    public func logout() async {
        self.isLoading = true
        do {
            try await self.logoutUseCase.execute()
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to logout: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}
