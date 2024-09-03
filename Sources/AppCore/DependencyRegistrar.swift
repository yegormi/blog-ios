import Data
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
        let keychainStorage = KeychainStorage()
        self.container.register(keychainStorage as KeychainStorageProtocol)

        let sessionStorage = SessionStorage(keychain: keychainStorage)
        self.container.register(sessionStorage as SessionStorageProtocol)

        let apiClient = APIClient(sessionProvider: sessionStorage)
        self.container.register(apiClient)

        let dataSources = self.registerDataSources(apiClient: apiClient, sessionStorage: sessionStorage)
        let repositories = self.registerRepositories(dataSources: dataSources)
        let useCases = self.registerUseCases(repositories: repositories)

        self.registerViewModels(useCases: useCases)
    }

    private func registerDataSources(apiClient: APIClient, sessionStorage _: SessionStorageProtocol) -> DataSources {
        let keychainStorage = KeychainStorage()
        let sessionStorage = SessionStorage(keychain: keychainStorage)

        let articleDataSource = ArticleRemoteDataSource(apiClient: apiClient)
        let userDataSource = UserRemoteDataSource(apiClient: apiClient, sessionStorage: sessionStorage)
        let commentDataSource = CommentRemoteDataSource(apiClient: apiClient)

        self.container.register(keychainStorage as KeychainStorageProtocol)
        self.container.register(sessionStorage as SessionStorageProtocol)

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
        // Article Use Cases
        let fetchArticlesUseCase = FetchArticlesUseCaseImpl(articleRepository: repositories.articleRepository)
        let getArticleUseCase = GetArticleUseCaseImpl(articleRepository: repositories.articleRepository)
        let createArticleUseCase = CreateArticleUseCaseImpl(articleRepository: repositories.articleRepository)
        let updateArticleUseCase = UpdateArticleUseCaseImpl(articleRepository: repositories.articleRepository)
        let deleteArticleUseCase = DeleteArticleUseCaseImpl(articleRepository: repositories.articleRepository)

        let articleUseCases = ArticleUseCases(
            fetchArticlesUseCase: fetchArticlesUseCase,
            getArticleUseCase: getArticleUseCase,
            createArticleUseCase: createArticleUseCase,
            updateArticleUseCase: updateArticleUseCase,
            deleteArticleUseCase: deleteArticleUseCase
        )

        // Auth Use Cases
        let loginUseCase = LoginUseCaseImpl(userRepository: repositories.userRepository)
        let registerUseCase = RegisterUseCaseImpl(userRepository: repositories.userRepository)
        let logoutUseCase = LogoutUseCaseImpl(userRepository: repositories.userRepository)
        let getCurrentUserUseCase = GetCurrentUserUseCaseImpl(userRepository: repositories.userRepository)
        let uploadAvatarUseCase = UploadAvatarUseCaseImpl(userRepository: repositories.userRepository)
        let removeAvatarUseCase = RemoveAvatarUseCaseImpl(userRepository: repositories.userRepository)

        let authUseCases = AuthUseCases(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            logoutUseCase: logoutUseCase,
            getCurrentUserUseCase: getCurrentUserUseCase,
            uploadAvatarUseCase: uploadAvatarUseCase,
            removeAvatarUseCase: removeAvatarUseCase
        )

        // Comment Use Cases
        let fetchCommentsUseCase = FetchCommentsUseCaseImpl(commentRepository: repositories.commentRepository)
        let createCommentUseCase = CreateCommentUseCaseImpl(commentRepository: repositories.commentRepository)
        let deleteCommentUseCase = DeleteCommentUseCaseImpl(commentRepository: repositories.commentRepository)

        let commentUseCases = CommentUseCases(
            fetchCommentsUseCase: fetchCommentsUseCase,
            createCommentUseCase: createCommentUseCase,
            deleteCommentUseCase: deleteCommentUseCase
        )

        // Session Use Cases
        let authenticateUserUseCase = AuthenticateUserUseCaseImpl(sessionRepository: repositories.sessionRepository)
        let getSessionUserUseCase = GetSessionUserUseCaseImpl(sessionRepository: repositories.sessionRepository)
        let getTokenUseCase = GetTokenUseCaseImpl(sessionRepository: repositories.sessionRepository)
        let observeCurrentUserUseCase = ObserveCurrentUserUseCaseImpl(sessionRepository: repositories.sessionRepository)
        let sessionLogoutUseCase = SessionLogoutUseCaseImpl(sessionRepository: repositories.sessionRepository)
        let setTokenUseCase = SetTokenUseCaseImpl(sessionRepository: repositories.sessionRepository)

        let sessionUseCases = SessionUseCases(
            authenticateUserUseCase: authenticateUserUseCase,
            getSessionUserUseCase: getSessionUserUseCase,
            getTokenUseCase: getTokenUseCase,
            observeCurrentUserUseCase: observeCurrentUserUseCase,
            sessionLogoutUseCase: sessionLogoutUseCase,
            setTokenUseCase: setTokenUseCase
        )

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
            deleteCommentUseCase: useCases.commentUseCases.deleteCommentUseCase
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
