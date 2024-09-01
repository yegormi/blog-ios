import Domain
import SwiftUI

public struct ArticleDetailView: View {
    @StateObject var viewModel: ArticleDetailViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    public init(viewModel: ArticleDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
                    ForEach(self.viewModel.comments) { comment in
                        CommentRow(comment: comment) {
                            Task { await self.viewModel.deleteComment(comment) }
                        }
                    }
                }

                if self.authViewModel.isLoggedIn {
                    HStack {
                        TextField("Add a comment", text: self.$viewModel.newCommentContent)
                        Button("Post") {
                            Task { await self.viewModel.addComment() }
                        }
                        .disabled(self.viewModel.newCommentContent.isEmpty)
                    }
                } else {
                    Text("Please log in to add comments")
                        .italic()
                }
            }
            .padding()
        }
        .navigationTitle(self.viewModel.article.title)
        .onAppear {
            Task { await self.viewModel.fetchComments() }
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
