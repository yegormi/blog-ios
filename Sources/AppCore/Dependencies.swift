import Data
import Domain
import Foundation

struct DataSources {
    struct Local {
        let keychainStorage: KeychainStorageProtocol
        let sessionStorage: SessionStorageProtocol
    }

    struct Remote {
        let articleDataSource: ArticleRemoteDataSource
        let userDataSource: UserRemoteDataSource
        let commentDataSource: CommentRemoteDataSource
    }

    let local: Local
    let remote: Remote
}

struct Repositories {
    let articleRepository: ArticleRepositoryProtocol
    let userRepository: UserRepositoryProtocol
    let commentRepository: CommentRepositoryProtocol
    let sessionRepository: SessionRepositoryProtocol
}

struct UseCases {
    let articleUseCases: ArticleUseCases
    let authUseCases: AuthUseCases
    let commentUseCases: CommentUseCases
    let sessionUseCases: SessionUseCases
}

struct ArticleUseCases {
    let fetchArticlesUseCase: FetchArticlesUseCase
    let getArticleUseCase: GetArticleUseCase
    let createArticleUseCase: CreateArticleUseCase
    let updateArticleUseCase: UpdateArticleUseCase
    let deleteArticleUseCase: DeleteArticleUseCase
}

struct AuthUseCases {
    let loginUseCase: LoginUseCase
    let registerUseCase: RegisterUseCase
    let logoutUseCase: LogoutUseCase
    let getCurrentUserUseCase: GetCurrentUserUseCase
    let uploadAvatarUseCase: UploadAvatarUseCase
    let removeAvatarUseCase: RemoveAvatarUseCase
}

struct CommentUseCases {
    let fetchCommentsUseCase: FetchCommentsUseCase
    let createCommentUseCase: CreateCommentUseCase
    let deleteCommentUseCase: DeleteCommentUseCase
}

struct SessionUseCases {
    let authenticateUserUseCase: AuthenticateUserUseCase
    let getSessionUserUseCase: GetSessionUserUseCase
    let getTokenUseCase: GetTokenUseCase
    let observeCurrentUserUseCase: ObserveCurrentUserUseCase
    let sessionLogoutUseCase: SessionLogoutUseCase
    let setTokenUseCase: SetTokenUseCase
}
