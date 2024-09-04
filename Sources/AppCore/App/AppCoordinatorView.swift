import Presentation
import SwiftUI

struct AppCoordinatorView: View {
    @StateObject var coordinator: AppCoordinator
    let loggedInCoordinator: LoggedInCoordinator
    let authViewModel: AuthViewModel

    init(coordinator: AppCoordinator) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self.loggedInCoordinator = LoggedInCoordinator(container: coordinator.diContainer)
        self.authViewModel = coordinator.diContainer.resolve() as AuthViewModel
    }

    var body: some View {
        Group {
            switch self.coordinator.state {
            case .splash:
                SplashView()
            case .auth:
                AuthView(viewModel: self.authViewModel)
            case let .loggedIn(state):
                LoggedInCoordinatorView(
                    coordinator: self.loggedInCoordinator,
                    initialState: state
                )
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: self.coordinator.state)
    }
}
