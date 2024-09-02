import Domain
import Foundation
import OSLog

private let logger = Logger(subsystem: "ArtileDetail", category: "Presentation")

@MainActor
public class ArticleDetailViewModel: ObservableObject {
    @Published public var article: Article
    @Published public var comments: [Comment] = []
    @Published public var newCommentContent = ""
    @Published public var isLoading = false
    @Published public var errorMessage: String?

    private let fetchCommentsUseCase: FetchCommentsUseCase
    private let createCommentUseCase: CreateCommentUseCase
    private let deleteCommentUseCase: DeleteCommentUseCase

    public init(
        article: Article,
        fetchCommentsUseCase: FetchCommentsUseCase,
        createCommentUseCase: CreateCommentUseCase,
        deleteCommentUseCase: DeleteCommentUseCase
    ) {
        self.article = article
        self.fetchCommentsUseCase = fetchCommentsUseCase
        self.createCommentUseCase = createCommentUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
    }

    public func fetchComments() async {
        self.isLoading = true
        do {
            self.comments = try await self.fetchCommentsUseCase.execute(articleId: self.article.id)
            self.isLoading = false
        } catch {
            let error = "Failed to fetch comments: \(error.localizedDescription)"
            logger.error("\(error)")
            self.errorMessage = error
            self.isLoading = false
        }
    }

    public func addComment() async {
        guard !self.newCommentContent.isEmpty else { return }
        do {
            let newComment = try await self.createCommentUseCase.execute(
                content: self.newCommentContent,
                articleId: self.article.id
            )
            self.comments.append(newComment)
            self.newCommentContent = ""
        } catch {
            self.errorMessage = "Failed to add comment: \(error.localizedDescription)"
        }
    }

    public func deleteComment(_ comment: Comment) async {
        do {
            try await self.deleteCommentUseCase.execute(id: comment.id)
            self.comments.removeAll { $0.id == comment.id }
        } catch {
            self.errorMessage = "Failed to delete comment: \(error.localizedDescription)"
        }
    }
}
