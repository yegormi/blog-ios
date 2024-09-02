import Domain
import SwiftUI

struct CommentRow: View {
    let comment: Comment
    let onDelete: () -> Void
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.comment.content)
                .font(.body)
            HStack {
                Text("By: \(self.comment.user.username)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                if self.authViewModel.currentUser?.id == self.comment.user.id {
                    Button(action: self.onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}
