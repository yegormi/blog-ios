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
        let tokenManager = TokenManager()
        self.container.register(tokenManager)

        let apiClient = APIClient(tokenManager: tokenManager)
        self.container.register(apiClient)

        let dataSources = self.registerDataSources(apiClient: apiClient, tokenManager: tokenManager)
        let repositories = self.registerRepositories(dataSources: dataSources)
        let useCases = self.registerUseCases(repositories: repositories)
        self.registerViewModels(useCases: useCases)
    }

    private func registerDataSources(apiClient: APIClient, tokenManager: TokenManager) -> DataSources {
        let articleDataSource = ArticleRemoteDataSource(apiClient: apiClient)
        let userDataSource = UserRemoteDataSource(apiClient: apiClient, tokenManager: tokenManager)
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

        self.container.register(articleRepository as ArticleRepositoryProtocol)
        self.container.register(userRepository as UserRepositoryProtocol)
        self.container.register(commentRepository as CommentRepositoryProtocol)

        return Repositories(
            articleRepository: articleRepository,
            userRepository: userRepository,
            commentRepository: commentRepository
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
