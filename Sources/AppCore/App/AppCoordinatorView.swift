import Presentation
import SwiftUI

struct AppCoordinatorView: View {
    @StateObject var coordinator: AppCoordinator

    var body: some View {
        Group {
            switch self.coordinator.state {
            case .splash:
                SplashView()
            case .auth:
                AuthView(viewModel: self.coordinator.diContainer.resolve() as AuthViewModel)
            case let .loggedIn(loggedInState):
                LoggedInCoordinatorView(
                    coordinator: LoggedInCoordinator(container: self.coordinator.diContainer),
                    initialState: loggedInState
                )
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: self.coordinator.state)
    }
}
