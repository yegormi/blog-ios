import SwiftUI
import Domain
import Presentation
import Data
import Networking

public struct AppCore {
    private let container: DIContainer

    public init(baseURL: URL) {
        let container = AppDIContainer()
        let registrar = DependencyRegistrar(container: container, baseURL: baseURL)
        registrar.registerDependencies()
        self.container = container
        AppDIContainer.initialize(container)
    }

    public func makeRootView() -> some View {
        AppView()
            .environmentObject(container.resolve() as ArticleListViewModel)
            .environmentObject(container.resolve() as AuthViewModel)
    }
}

public struct AppView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    public init() {}

    public var body: some View {
        if authViewModel.isLoggedIn {
            ArticleListView()
        } else {
            LoginView()
        }
    }
}
