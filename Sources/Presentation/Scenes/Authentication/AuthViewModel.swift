import Domain
import Foundation

@MainActor
public class AuthViewModel: ObservableObject {
    @Published public var isLoggedIn = false
    @Published public var currentUser: User?
    @Published public var showError = false
    @Published public var errorMessage = ""

    private let authUseCase: AuthUseCases

    public init(authUseCase: AuthUseCases) {
        self.authUseCase = authUseCase
        Task { await self.checkCurrentUser() }
    }

    public func checkCurrentUser() async {
        do {
            let user = try await authUseCase.getCurrentUser()
            self.currentUser = user
            self.isLoggedIn = user != nil
        } catch {
            print("Error checking current user: \(error)")
        }
    }

    public func login(email: String, password: String) async {
        do {
            let user = try await authUseCase.login(email: email, password: password)
            self.currentUser = user
            self.isLoggedIn = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }

    public func logout() async {
        do {
            try await self.authUseCase.logout()
            self.currentUser = nil
            self.isLoggedIn = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }

    public func register(username: String, email: String, password: String) async {
        do {
            let user = try await authUseCase.register(username: username, email: email, password: password)
            self.currentUser = user
            self.isLoggedIn = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
}
