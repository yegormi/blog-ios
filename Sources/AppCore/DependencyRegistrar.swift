import Data
import Domain
import Foundation
import Networking
import Presentation

public struct DependencyRegistrar {
    private let container: DIContainer
    private let apiClient: APIClient

    public init(container: DIContainer, baseURL: URL) {
        self.container = container
        self.apiClient = APIClient(baseURL: baseURL)
    }

    @MainActor
    public func registerDependencies() {
        let dataSources = self.registerDataSources()
        let repositories = self.registerRepositories(dataSources: dataSources)
        let useCases = self.registerUseCases(repositories: repositories)
        self.registerViewModels(useCases: useCases)
    }

    private func registerDataSources() -> DataSources {
        let articleDataSource = ArticleRemoteDataSource(apiClient: apiClient)
        let userDataSource = UserRemoteDataSource(apiClient: apiClient)
        let commentDataSource = CommentRemoteDataSource(apiClient: apiClient)

        self.container.register(articleDataSource)
        self.container.register(userDataSource)
        self.container.register(commentDataSource)

        return DataSources(
            articleDataSource: articleDataSource,
            userDataSource: userDataSource,
            commentDataSource: commentDataSource
        )
    }

    private func registerRepositories(dataSources: DataSources) -> Repositories {
        let articleRepository = ArticleRepository(remoteDataSource: dataSources.articleDataSource)
        let userRepository = UserRepository(remoteDataSource: dataSources.userDataSource)
        let commentRepository = CommentRepository(remoteDataSource: dataSources.commentDataSource)

        self.container.register(articleRepository)
        self.container.register(userRepository)
        self.container.register(commentRepository)

        return Repositories(
            articleRepository: articleRepository,
            userRepository: userRepository,
            commentRepository: commentRepository
        )
    }

    private func registerUseCases(repositories: Repositories) -> UseCases {
        let articleUseCases = repositories.articleRepository as ArticleUseCases
        let authUseCases = repositories.userRepository as AuthUseCases
        let commentUseCases = repositories.commentRepository as CommentUseCases

        self.container.register(articleUseCases)
        self.container.register(authUseCases)
        self.container.register(commentUseCases)

        return UseCases(
            articleUseCases: articleUseCases,
            authUseCases: authUseCases,
            commentUseCases: commentUseCases
        )
    }

    @MainActor
    private func registerViewModels(useCases: UseCases) {
        let articleListViewModel = ArticleListViewModel(articleUseCase: useCases.articleUseCases)
        let authViewModel = AuthViewModel(authUseCase: useCases.authUseCases)

        self.container.register(articleListViewModel)
        self.container.register(authViewModel)
    }
}
