import Domain

public protocol CreateArticleViewModelFactory {
    func makeViewModel() -> CreateArticleViewModel
}

public final class DefaultCreateArticleViewModelFactory: @preconcurrency CreateArticleViewModelFactory {
    private let createArticleUseCase: CreateArticleUseCase

    public init(createArticleUseCase: CreateArticleUseCase) {
        self.createArticleUseCase = createArticleUseCase
    }

    @MainActor
    public func makeViewModel() -> CreateArticleViewModel {
        CreateArticleViewModel(createArticleUseCase: self.createArticleUseCase)
    }
}
