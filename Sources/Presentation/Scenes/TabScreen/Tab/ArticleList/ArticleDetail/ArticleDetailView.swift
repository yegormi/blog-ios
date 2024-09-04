import DIContainer
import Domain
import SwiftUI

public struct ArticleDetailView: View {
    @StateObject var viewModel: ArticleDetailViewModel

    public init(viewModel: ArticleDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(self.viewModel.article.content)
                    .font(.body)

                Divider()

                Text("Comments")
                    .font(.headline)

                if self.viewModel.isLoading {
                    ProgressView()
                } else {
                    if let user = viewModel.user {
                        ForEach(self.viewModel.comments) { comment in
                            CommentRow(user: user, comment: comment) {
                                Task { await self.viewModel.deleteComment(comment) }
                            }
                        }
                    }
                }

                HStack {
                    TextField("Add a comment", text: self.$viewModel.newCommentContent)
                    Button("Post") {
                        Task { await self.viewModel.addComment() }
                    }
                    .disabled(self.viewModel.newCommentContent.isEmpty)
                }
            }
            .padding()
        }
        .navigationTitle(self.viewModel.article.title)
        .task {
            await self.viewModel.getUser()
            await self.viewModel.fetchComments()
        }
        .alert("Error", isPresented: .constant(self.viewModel.errorMessage != nil), actions: {
            Button("OK", role: .cancel) {
                self.viewModel.errorMessage = nil
            }
        }, message: {
            Text(self.viewModel.errorMessage ?? "")
        })
    }
}
