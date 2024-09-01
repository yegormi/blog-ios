import Data
import Domain
import Foundation

private struct DataSources {
    let articleDataSource: ArticleRemoteDataSource
    let userDataSource: UserRemoteDataSource
    let commentDataSource: CommentRemoteDataSource
}

private struct Repositories {
    let articleRepository: ArticleRepository
    let userRepository: UserRepository
    let commentRepository: CommentRepository
}

private struct UseCases {
    let articleUseCases: ArticleUseCases
    let authUseCases: AuthUseCases
    let commentUseCases: CommentUseCases
}
