import Domain
import Foundation
import os

private let logger = Logger(subsystem: "CreateArticleViewModel", category: "Presentation")

@MainActor
public final class CreateArticleViewModel: ObservableObject {
    @Published public var title = ""
    @Published public var content = ""
    @Published public var isLoading = false
    @Published public var errorMessage: String?

    private let createArticleUseCase: CreateArticleUseCase

    public init(createArticleUseCase: CreateArticleUseCase) {
        self.createArticleUseCase = createArticleUseCase
    }

    public func createArticle() async {
        guard !self.title.isEmpty, !self.content.isEmpty else {
            self.errorMessage = "Title and content cannot be empty"
            return
        }

        self.isLoading = true
        do {
            _ = try await self.createArticleUseCase.execute(title: self.title, content: self.content)
            self.title = ""
            self.content = ""
            self.isLoading = false
        } catch {
            let title = "Failed to create article: \(error.localizedDescription)"
            let description = "Description: \(String(describing: error))"
            let message = "\(title)\n\(description)"
            logger.error("\(message)")
            self.errorMessage = message
            self.isLoading = false
        }
    }
}
