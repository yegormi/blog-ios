import Data
import Domain
import Foundation

struct DataSources {
    let articleDataSource: ArticleRemoteDataSource
    let userDataSource: UserRemoteDataSource
    let commentDataSource: CommentRemoteDataSource
}

struct Repositories {
    let articleRepository: ArticleRepositoryProtocol
    let userRepository: UserRepositoryProtocol
    let commentRepository: CommentRepositoryProtocol
}

struct UseCases {
    let articleUseCases: ArticleUseCases
    let authUseCases: AuthUseCases
    let commentUseCases: CommentUseCases
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
}
struct CommentUseCases {
    let fetchCommentsUseCase: FetchCommentsUseCase
    let createCommentUseCase: CreateCommentUseCase
    let deleteCommentUseCase: DeleteCommentUseCase
}
