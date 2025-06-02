import Domain
import SwiftUI

public struct CreateArticleView: View {
    @StateObject var viewModel: CreateArticleViewModel

    let onDismiss: () -> Void

    public init(viewModel: CreateArticleViewModel, onDismiss: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onDismiss = onDismiss
    }

    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Article Details")) {
                    TextField("Title", text: self.$viewModel.title)
                    TextEditor(text: self.$viewModel.content)
                        .frame(minHeight: 200)
                }

                Section {
                    Button(action: {
                        Task {
                            await self.viewModel.createArticle()
                            self.onDismiss()
                        }
                    }) {
                        if self.viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Create Article")
                        }
                    }
                    .disabled(self.viewModel.title.isEmpty || self.viewModel.content.isEmpty || self.viewModel.isLoading)
                }
            }
            .navigationTitle("New Article")
            .navigationBarItems(trailing: Button("Cancel") {
                self.onDismiss()
            })
            .alert("Error", isPresented: .constant(self.viewModel.errorMessage != nil), actions: {
                Button("OK", role: .cancel) {
                    self.viewModel.errorMessage = nil
                }
            }, message: {
                Text(self.viewModel.errorMessage ?? "")
            })
        }
    }
}
