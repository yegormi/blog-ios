import Domain
import Foundation
import os

private let logger = Logger(subsystem: "AuthViewModel", category: "Presentation")

@MainActor
public final class AuthViewModel: ObservableObject {
    @Published public var currentUser: User?
    @Published public var showError = false
    @Published public var errorMessage = ""

    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private let logoutUseCase: LogoutUseCase
    private let getCurrentUserUseCase: GetCurrentUserUseCase

    public init(
        loginUseCase: LoginUseCase,
        registerUseCase: RegisterUseCase,
        logoutUseCase: LogoutUseCase,
        getCurrentUserUseCase: GetCurrentUserUseCase
    ) {
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.logoutUseCase = logoutUseCase
        self.getCurrentUserUseCase = getCurrentUserUseCase
    }

    public func login(email: String, password: String) async {
        do {
            let user = try await self.loginUseCase.execute(email: email, password: password)
            self.currentUser = user
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }

    public func logout() async {
        do {
            try await self.logoutUseCase.execute()
            self.currentUser = nil
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }

    public func register(username: String, email: String, password: String) async {
        do {
            let user = try await registerUseCase.execute(username: username, email: email, password: password)
            self.currentUser = user
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
}
