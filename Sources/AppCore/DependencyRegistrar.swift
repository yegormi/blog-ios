import Data
import DIContainer
import Domain
import Foundation
import Networking
import Presentation

public struct DependencyRegistrar {
    private let container: DIContainer

    public init(container: DIContainer) {
        self.container = container
    }

    @MainActor
    public func registerDependencies() {
        let storageDependencies = self.registerStorageDependencies()
        let apiClient = self.registerAPIClient(sessionStorage: storageDependencies.sessionStorage)
        let dataSources = self.registerDataSources(
            apiClient: apiClient,
            sessionStorage: storageDependencies.sessionStorage,
            keychainStorage: storageDependencies.keychainStorage
        )
        let repositories = self.registerRepositories(dataSources: dataSources)
        let useCases = self.registerUseCases(repositories: repositories)
        self.registerViewModels(useCases: useCases)
    }

    private func registerStorageDependencies()
        -> (keychainStorage: KeychainStorageProtocol, sessionStorage: SessionStorageProtocol)
    {
        let keychainStorage = KeychainStorage()
        let sessionStorage = SessionStorage(keychain: keychainStorage)

        self.container.register(keychainStorage as KeychainStorageProtocol)
        self.container.register(sessionStorage as SessionStorageProtocol)

        return (keychainStorage, sessionStorage)
    }

    private func registerAPIClient(sessionStorage: SessionStorageProtocol) -> APIClient {
        let apiClient = APIClient(sessionProvider: sessionStorage)
        self.container.register(apiClient)
        return apiClient
    }

    private func registerDataSources(
        apiClient: APIClient,
        sessionStorage: SessionStorageProtocol,
        keychainStorage: KeychainStorageProtocol
    ) -> DataSources {
        let articleDataSource = ArticleRemoteDataSource(apiClient: apiClient)
        let userDataSource = UserRemoteDataSource(apiClient: apiClient, sessionStorage: sessionStorage)
        let commentDataSource = CommentRemoteDataSource(apiClient: apiClient)

        self.container.register(articleDataSource)
        self.container.register(userDataSource)
        self.container.register(commentDataSource)

        return DataSources(
            local: DataSources.Local(
                keychainStorage: keychainStorage,
                sessionStorage: sessionStorage
            ),
            remote: DataSources.Remote(
                articleDataSource: articleDataSource,
                userDataSource: userDataSource,
                commentDataSource: commentDataSource
            )
        )
    }

    private func registerRepositories(dataSources: DataSources) -> Repositories {
        let articleRepository = ArticleRepository(remoteDataSource: dataSources.remote.articleDataSource)
        let userRepository = UserRepository(remoteDataSource: dataSources.remote.userDataSource)
        let commentRepository = CommentRepository(remoteDataSource: dataSources.remote.commentDataSource)
        let sessionRepository = SessionRepository(sessionStorage: dataSources.local.sessionStorage)

        self.container.register(articleRepository as ArticleRepositoryProtocol)
        self.container.register(userRepository as UserRepositoryProtocol)
        self.container.register(commentRepository as CommentRepositoryProtocol)
        self.container.register(sessionRepository as SessionRepositoryProtocol)

        return Repositories(
            articleRepository: articleRepository,
            userRepository: userRepository,
            commentRepository: commentRepository,
            sessionRepository: sessionRepository
        )
    }

    private func registerUseCases(repositories: Repositories) -> UseCases {
        let articleUseCases = self.registerArticleUseCases(repository: repositories.articleRepository)
        let authUseCases = self.registerAuthUseCases(repository: repositories.userRepository)
        let commentUseCases = self.registerCommentUseCases(repository: repositories.commentRepository)
        let sessionUseCases = self.registerSessionUseCases(repository: repositories.sessionRepository)

        self.container.register(articleUseCases)
        self.container.register(authUseCases)
        self.container.register(commentUseCases)
        self.container.register(sessionUseCases)

        return UseCases(
            articleUseCases: articleUseCases,
            authUseCases: authUseCases,
            commentUseCases: commentUseCases,
            sessionUseCases: sessionUseCases
        )
    }

    private func registerArticleUseCases(repository: ArticleRepositoryProtocol) -> ArticleUseCases {
        ArticleUseCases(
            fetchArticlesUseCase: FetchArticlesUseCaseImpl(articleRepository: repository),
            getArticleUseCase: GetArticleUseCaseImpl(articleRepository: repository),
            createArticleUseCase: CreateArticleUseCaseImpl(articleRepository: repository),
            updateArticleUseCase: UpdateArticleUseCaseImpl(articleRepository: repository),
            deleteArticleUseCase: DeleteArticleUseCaseImpl(articleRepository: repository)
        )
    }

    private func registerAuthUseCases(repository: UserRepositoryProtocol) -> AuthUseCases {
        AuthUseCases(
            loginUseCase: LoginUseCaseImpl(userRepository: repository),
            registerUseCase: RegisterUseCaseImpl(userRepository: repository),
            logoutUseCase: LogoutUseCaseImpl(userRepository: repository),
            getCurrentUserUseCase: GetCurrentUserUseCaseImpl(userRepository: repository),
            uploadAvatarUseCase: UploadAvatarUseCaseImpl(userRepository: repository),
            removeAvatarUseCase: RemoveAvatarUseCaseImpl(userRepository: repository)
        )
    }

    private func registerCommentUseCases(repository: CommentRepositoryProtocol) -> CommentUseCases {
        CommentUseCases(
            fetchCommentsUseCase: FetchCommentsUseCaseImpl(commentRepository: repository),
            createCommentUseCase: CreateCommentUseCaseImpl(commentRepository: repository),
            deleteCommentUseCase: DeleteCommentUseCaseImpl(commentRepository: repository)
        )
    }

    private func registerSessionUseCases(repository: SessionRepositoryProtocol) -> SessionUseCases {
        SessionUseCases(
            authenticateUserUseCase: AuthenticateUserUseCaseImpl(sessionRepository: repository),
            getSessionUserUseCase: GetSessionUserUseCaseImpl(sessionRepository: repository),
            getTokenUseCase: GetTokenUseCaseImpl(sessionRepository: repository),
            observeCurrentUserUseCase: ObserveCurrentUserUseCaseImpl(sessionRepository: repository),
            sessionLogoutUseCase: SessionLogoutUseCaseImpl(sessionRepository: repository),
            setTokenUseCase: SetTokenUseCaseImpl(sessionRepository: repository)
        )
    }

    @MainActor
    private func registerViewModels(useCases: UseCases) {
        let articleListViewModel = ArticleListViewModel(
            fetchArticlesUseCase: useCases.articleUseCases.fetchArticlesUseCase
        )
        let authViewModel = AuthViewModel(
            loginUseCase: useCases.authUseCases.loginUseCase,
            registerUseCase: useCases.authUseCases.registerUseCase,
            logoutUseCase: useCases.authUseCases.logoutUseCase,
            getCurrentUserUseCase: useCases.authUseCases.getCurrentUserUseCase
        )
        let articleDetailViewModelFactory = DefaultArticleDetailViewModelFactory(
            fetchCommentsUseCase: useCases.commentUseCases.fetchCommentsUseCase,
            createCommentUseCase: useCases.commentUseCases.createCommentUseCase,
            deleteCommentUseCase: useCases.commentUseCases.deleteCommentUseCase,
            getCurrentUserUseCase: useCases.authUseCases.getCurrentUserUseCase
        )
        let profileViewModel = ProfileViewModel(
            getCurrentUserUseCase: useCases.authUseCases.getCurrentUserUseCase,
            uploadAvatarUseCase: useCases.authUseCases.uploadAvatarUseCase,
            removeAvatarUseCase: useCases.authUseCases.removeAvatarUseCase,
            logoutUseCase: useCases.authUseCases.logoutUseCase
        )

        self.container.register(articleListViewModel)
        self.container.register(authViewModel)
        self.container.register(articleDetailViewModelFactory as ArticleDetailViewModelFactory)
        self.container.register(profileViewModel)
    }
}
