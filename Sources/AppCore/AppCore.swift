import Data
import Domain
import Presentation
import SwiftUI

@MainActor
public struct AppCore {
    private let container: DIContainer

    public init() {
        let container = AppDIContainer()
        let registrar = DependencyRegistrar(container: container)
        registrar.registerDependencies()
        self.container = container
        AppDIContainer.initialize(container)
    }

    public func makeRootView() -> some View {
        let authViewModel: AuthViewModel = self.container.resolve()
        let articleListViewModel: ArticleListViewModel = self.container.resolve()
        let articleDetailViewModelFactory: ArticleDetailViewModelFactory = self.container.resolve()
        let profileViewModel: ProfileViewModel = self.container.resolve()

        return AppView(
            authViewModel: authViewModel,
            articleListViewModel: articleListViewModel,
            profileViewModel: profileViewModel,
            articleDetailViewModelFactory: articleDetailViewModelFactory
        )
        .environmentObject(self.container.resolve() as ArticleListViewModel)
        .environmentObject(self.container.resolve() as AuthViewModel)
    }
}

public struct AppView: View {
    @StateObject var authViewModel: AuthViewModel
    @StateObject var articleListViewModel: ArticleListViewModel
    @StateObject var profileViewModel: ProfileViewModel
    let articleDetailViewModelFactory: ArticleDetailViewModelFactory

    public init(
        authViewModel: AuthViewModel,
        articleListViewModel: ArticleListViewModel,
        profileViewModel: ProfileViewModel,
        articleDetailViewModelFactory: ArticleDetailViewModelFactory
    ) {
        self._authViewModel = StateObject(wrappedValue: authViewModel)
        self._articleListViewModel = StateObject(wrappedValue: articleListViewModel)
        self._profileViewModel = StateObject(wrappedValue: profileViewModel)
        self.articleDetailViewModelFactory = articleDetailViewModelFactory
    }

    public var body: some View {
        if self.authViewModel.isLoggedIn {
            TabView {
                NavigationView {
                    ArticleListView(
                        viewModel: self.articleListViewModel
                    ) { article in
                        self.articleDetailViewModelFactory.makeViewModel(for: article)
                    }
                }
                .tabItem {
                    Label("Articles", systemImage: "list.bullet")
                }

                NavigationView {
                    ProfileView(viewModel: self.profileViewModel)
                }
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            }
        } else {
            LoginView(viewModel: self.authViewModel)
        }
    }
}
