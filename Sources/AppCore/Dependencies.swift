import Data
import Domain
import Foundation

internal struct DataSources {
    let articleDataSource: ArticleRemoteDataSource
    let userDataSource: UserRemoteDataSource
    let commentDataSource: CommentRemoteDataSource
}

internal struct Repositories {
    let articleRepository: ArticleRepository
    let userRepository: UserRepository
    let commentRepository: CommentRepository
}

internal struct UseCases {
    let articleUseCases: ArticleUseCases
    let authUseCases: AuthUseCases
    let commentUseCases: CommentUseCases
}
