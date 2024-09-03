import Domain

public protocol ArticleDetailViewModelFactory {
    func makeViewModel(for article: Article) -> ArticleDetailViewModel
}

public final class DefaultArticleDetailViewModelFactory: ArticleDetailViewModelFactory {
    private let fetchCommentsUseCase: FetchCommentsUseCase
    private let createCommentUseCase: CreateCommentUseCase
    private let deleteCommentUseCase: DeleteCommentUseCase
    private let getCurrentUserUseCase: GetCurrentUserUseCase

    public init(
        fetchCommentsUseCase: FetchCommentsUseCase,
        createCommentUseCase: CreateCommentUseCase,
        deleteCommentUseCase: DeleteCommentUseCase,
        getCurrentUserUseCase: GetCurrentUserUseCase
    ) {
        self.fetchCommentsUseCase = fetchCommentsUseCase
        self.createCommentUseCase = createCommentUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
        self.getCurrentUserUseCase = getCurrentUserUseCase
    }

    @MainActor
    public func makeViewModel(for article: Article) -> ArticleDetailViewModel {
        ArticleDetailViewModel(
            article: article,
            fetchCommentsUseCase: self.fetchCommentsUseCase,
            createCommentUseCase: self.createCommentUseCase,
            deleteCommentUseCase: self.deleteCommentUseCase,
            getCurrentUserUserCase: self.getCurrentUserUseCase
        )
    }
}
