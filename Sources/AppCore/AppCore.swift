import Data
import Domain
import Networking
import Presentation
import SwiftUI

@MainActor
public struct AppCore {
    private let container: DIContainer

    public init() {
        let container = AppDIContainer()
        let registrar = DependencyRegistrar(container: container, baseURL: APIConfiguration.shared.baseURL)
        registrar.registerDependencies()
        self.container = container
        AppDIContainer.initialize(container)
    }

    public func makeRootView() -> some View {
        let authViewModel: AuthViewModel = self.container.resolve()
        let articleListViewModel: ArticleListViewModel = self.container.resolve()
        let articleDetailViewModelFactory: ArticleDetailViewModelFactory = self.container.resolve()

        return AppView(
            authViewModel: authViewModel,
            articleListViewModel: articleListViewModel,
            articleDetailViewModelFactory: articleDetailViewModelFactory
        )
        .environmentObject(self.container.resolve() as ArticleListViewModel)
        .environmentObject(self.container.resolve() as AuthViewModel)
    }
}

public struct AppView: View {
    @StateObject var authViewModel: AuthViewModel
    @StateObject var articleListViewModel: ArticleListViewModel
    let articleDetailViewModelFactory: ArticleDetailViewModelFactory

    public init(
        authViewModel: AuthViewModel,
        articleListViewModel: ArticleListViewModel,
        articleDetailViewModelFactory: ArticleDetailViewModelFactory
    ) {
        self._authViewModel = StateObject(wrappedValue: authViewModel)
        self._articleListViewModel = StateObject(wrappedValue: articleListViewModel)
        self.articleDetailViewModelFactory = articleDetailViewModelFactory
    }

    public var body: some View {
        if self.authViewModel.isLoggedIn {
            NavigationView {
                ArticleListView(
                    viewModel: self.articleListViewModel
                ) { article in
                    self.articleDetailViewModelFactory.makeViewModel(for: article)
                }
            }
        } else {
            LoginView(viewModel: self.authViewModel)
        }
    }
}
