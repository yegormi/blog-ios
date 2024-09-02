import Domain
import Presentation

public protocol ArticleDetailViewModelFactory {
    func makeViewModel(for article: Article) -> ArticleDetailViewModel
}

public final class DefaultArticleDetailViewModelFactory: ArticleDetailViewModelFactory {
    private let fetchCommentsUseCase: FetchCommentsUseCase
    private let createCommentUseCase: CreateCommentUseCase
    private let deleteCommentUseCase: DeleteCommentUseCase

    public init(
        fetchCommentsUseCase: FetchCommentsUseCase,
        createCommentUseCase: CreateCommentUseCase,
        deleteCommentUseCase: DeleteCommentUseCase
    ) {
        self.fetchCommentsUseCase = fetchCommentsUseCase
        self.createCommentUseCase = createCommentUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
    }

    @MainActor
    public func makeViewModel(for article: Article) -> ArticleDetailViewModel {
        ArticleDetailViewModel(
            article: article,
            fetchCommentsUseCase: self.fetchCommentsUseCase,
            createCommentUseCase: self.createCommentUseCase,
            deleteCommentUseCase: self.deleteCommentUseCase
        )
    }
}
