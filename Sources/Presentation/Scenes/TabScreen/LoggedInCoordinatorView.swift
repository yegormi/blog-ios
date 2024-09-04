import SwiftUI

public struct LoggedInCoordinatorView: View {
    @StateObject var coordinator: LoggedInCoordinator
    let articleListViewModel: ArticleListViewModel
    let articleDetailViewModelFactory: ArticleDetailViewModelFactory

    public init(coordinator: LoggedInCoordinator, initialState: LoggedInState) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        coordinator.state = initialState
        self.articleDetailViewModelFactory = coordinator.container.resolve() as ArticleDetailViewModelFactory
        self.articleListViewModel = coordinator.container.resolve() as ArticleListViewModel
    }

    public var body: some View {
        TabView(selection: self.$coordinator.state) {
            self.articlesTab
            self.profileTab
        }
    }

    private var articlesTab: some View {
        NavigationStack {
            ArticleListView(
                viewModel: self.articleListViewModel,
                container: self.coordinator.container,
                makeViewModel: self.articleDetailViewModelFactory.makeViewModel(for:)
            )
        }
        .tag(LoggedInState.articles)
        .tabItem {
            Label("Articles", systemImage: "list.bullet")
        }
    }

    private var profileTab: some View {
        NavigationStack {
            ProfileView(viewModel: self.coordinator.container.resolve())
        }
        .tag(LoggedInState.profile)
        .tabItem {
            Label("Profile", systemImage: "person")
        }
    }
}
