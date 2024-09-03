import Combine
import DIContainer
import Presentation
import SwiftUI

enum AppState: Equatable {
    case splash
    case auth
    case loggedIn(LoggedInState)
}

class AppCoordinator: Coordinator {
    @Published var state: AppState = .splash
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()

    public var diContainer: DIContainer { self.container }

    init(container: DIContainer) {
        self.container = container
    }

    @MainActor
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Task {
                await self.checkAuthentication()
            }
        }
    }

    private func checkAuthentication() async {
        let session: SessionUseCases = self.container.resolve()
        let auth: AuthUseCases = self.container.resolve()

        do {
            if let token = try session.getTokenUseCase.execute() {
                try session.setTokenUseCase.execute(token: token)
                let user = try await auth.getCurrentUserUseCase.execute()
                session.authenticateUserUseCase.execute(user: user)
                self.state = .loggedIn(.articles)
            } else {
                self.state = .auth
            }
        } catch {
            self.state = .auth
            try? session.sessionLogoutUseCase.execute()
        }
    }
}
