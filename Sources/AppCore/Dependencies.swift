import Data
import Domain
import Foundation

struct DataSources {
    let articleDataSource: ArticleRemoteDataSource
    let userDataSource: UserRemoteDataSource
    let commentDataSource: CommentRemoteDataSource
}

struct Repositories {
    let articleRepository: ArticleRepository
    let userRepository: UserRepository
    let commentRepository: CommentRepository
}

struct UseCases {
    let articleUseCases: ArticleUseCases
    let authUseCases: AuthUseCases
    let commentUseCases: CommentUseCases
}
