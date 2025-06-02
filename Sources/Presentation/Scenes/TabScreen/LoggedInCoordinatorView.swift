import DIContainer
import SwiftUI

public struct LoggedInCoordinatorView: View {
    @StateObject var coordinator: LoggedInCoordinator

    @Inject private var articleListViewModel: ArticleListViewModel
    @Inject private var articleDetailViewModelFactory: ArticleDetailViewModelFactory
    @Inject private var createArticleViewModelFactory: CreateArticleViewModelFactory

    public init(coordinator: LoggedInCoordinator, initialState: LoggedInState) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        coordinator.state = initialState
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
                makeViewModel: self.articleDetailViewModelFactory.makeViewModel(for:),
                makeCreateArticleViewModel: self.createArticleViewModelFactory.makeViewModel
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
