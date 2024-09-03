import SwiftUI

public struct LoggedInCoordinatorView: View {
    @StateObject var coordinator: LoggedInCoordinator
    let articleDetailViewModelFactory: ArticleDetailViewModelFactory

    public init(coordinator: LoggedInCoordinator, initialState: LoggedInState) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        coordinator.state = initialState
        self.articleDetailViewModelFactory = coordinator.container.resolve() as ArticleDetailViewModelFactory
    }

    public var body: some View {
        TabView(selection: self.$coordinator.state) {
            NavigationView {
                ArticleListView(
                    viewModel: self.coordinator.container.resolve(),
                    container: self.coordinator.container,
                    makeViewModel: self.articleDetailViewModelFactory.makeViewModel(for:)
                )
            }
            .tag(LoggedInState.articles)
            .tabItem {
                Label("Articles", systemImage: "list.bullet")
            }

            NavigationView {
                ProfileView(viewModel: self.coordinator.container.resolve())
            }
            .tag(LoggedInState.profile)
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}
