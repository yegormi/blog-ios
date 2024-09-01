import Foundation
import Domain

public class AuthViewModel: ObservableObject {
    @Published public var isLoggedIn = false
    @Published public var currentUser: User?
    @Published public var showError = false
    @Published public var errorMessage = ""

    private let authUseCase: AuthUseCases

    public init(authUseCase: AuthUseCases) {
        self.authUseCase = authUseCase
        checkCurrentUser()
    }

    public func checkCurrentUser() {
        Task {
            do {
                let user = try await authUseCase.getCurrentUser()
                await MainActor.run {
                    self.currentUser = user
                    self.isLoggedIn = user != nil
                }
            } catch {
                print("Error checking current user: \(error)")
            }
        }
    }

    public func login(email: String, password: String) {
        Task {
            do {
                let user = try await authUseCase.login(email: email, password: password)
                await MainActor.run {
                    self.currentUser = user
                    self.isLoggedIn = true
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }

    public func logout() {
        Task {
            do {
                try await authUseCase.logout()
                await MainActor.run {
                    self.currentUser = nil
                    self.isLoggedIn = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }

    public func register(username: String, email: String, password: String) {
        Task {
            do {
                let user = try await authUseCase.register(username: username, email: email, password: password)
                await MainActor.run {
                    self.currentUser = user
                    self.isLoggedIn = true
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }
}
