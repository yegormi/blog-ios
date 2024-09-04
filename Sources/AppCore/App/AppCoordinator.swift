import Combine
import DIContainer
import os
import Presentation
import SwiftUI

private let logger = Logger(subsystem: "AppCoordinator", category: "AppCore")

enum AppState: Equatable {
    case splash
    case auth
    case loggedIn(LoggedInState)
}

class AppCoordinator: Coordinator {
    @Published var state: AppState = .splash
    private let container: DIContainer

    public var diContainer: DIContainer { self.container }

    init(container: DIContainer) {
        self.container = container
    }

    func start() async {
        try? await Task.sleep(for: .seconds(1))
        logger.info("Splash screen displayed, proceeding to authentication check")
        await self.checkAuthentication()
    }

    @MainActor
    private func setState(_ newState: AppState) {
        logger.info("Updating app state to \(String(describing: newState))")
        self.state = newState
    }

    private func checkAuthentication() async {
        let session: SessionUseCases = self.container.resolve()
        let auth: AuthUseCases = self.container.resolve()

        do {
            if let token = try session.getTokenUseCase.execute() {
                logger.info("Token found, attempting to set token and get current user")
                try session.setTokenUseCase.execute(token: token)
                let user = try await auth.getCurrentUserUseCase.execute()
                logger.info("User authenticated successfully")
                session.authenticateUserUseCase.execute(user: user)
                await self.setState(.loggedIn(.articles))
            } else {
                logger.info("No token found, transitioning to auth state")
                await self.setState(.auth)
            }
        } catch {
            logger.error("Authentication error: \(error.localizedDescription)")
            await self.setState(.auth)
            do {
                try session.sessionLogoutUseCase.execute()
                logger.info("Session logged out due to authentication error")
            } catch {
                logger.error("Failed to log out session: \(error.localizedDescription)")
            }
        }

        logger.info("Starting to observe current user")
        for await user in session.observeCurrentUserUseCase.execute() {
            if user == nil {
                logger.info("User logged out, transitioning to auth state")
                await self.setState(.auth)
            } else {
                logger.info("User logged in, transitioning to logged in state")
                await self.setState(.loggedIn(.articles))
            }
        }
    }
}
