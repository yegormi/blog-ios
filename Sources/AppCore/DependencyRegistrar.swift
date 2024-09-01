import Foundation
import Domain
import Presentation
import Data
import Networking

public struct DependencyRegistrar {
    private let container: DIContainer
    private let apiClient: APIClient

    public init(container: DIContainer, baseURL: URL) {
        self.container = container
        self.apiClient = APIClient(baseURL: baseURL)
    }

    public func registerDependencies() {
        registerDataSources()
        registerRepositories()
        registerUseCases()
        registerViewModels()
    }

    private func registerDataSources() {
        container.register(ArticleRemoteDataSource(apiClient: apiClient))
        container.register(UserRemoteDataSource(apiClient: apiClient))
        container.register(CommentRemoteDataSource(apiClient: apiClient))
    }

    private func registerRepositories() {
        container.register(ArticleRepository(remoteDataSource: container.resolve()))
        container.register(UserRepository(remoteDataSource: container.resolve()))
        container.register(CommentRepository(remoteDataSource: container.resolve()))
    }

    private func registerUseCases() {
        container.register(container.resolve() as ArticleRepository as ArticleUseCases)
        container.register(container.resolve() as UserRepository as AuthUseCases)
        container.register(container.resolve() as CommentRepository as CommentUseCases)
    }

    private func registerViewModels() {
        container.register(ArticleListViewModel(articleUseCase: container.resolve()))
        container.register(AuthViewModel(authUseCase: container.resolve()))
    }
}
