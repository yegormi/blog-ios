import Data
import Domain
import Networking
import Presentation
import SwiftUI

@MainActor
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
            .environmentObject(self.container.resolve() as ArticleListViewModel)
            .environmentObject(self.container.resolve() as AuthViewModel)
    }
}

public struct AppView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    public init() {}

    public var body: some View {
        if self.authViewModel.isLoggedIn {
            ArticleListView()
        } else {
            LoginView()
        }
    }
}
