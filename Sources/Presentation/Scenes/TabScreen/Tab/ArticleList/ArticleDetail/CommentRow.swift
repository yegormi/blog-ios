import DIContainer
import Domain
import SwiftUI

struct CommentRow: View {
    let user: User
    let comment: Comment
    let onDelete: () -> Void

    init(user: User, comment: Comment, onDelete: @escaping () -> Void) {
        self.user = user
        self.comment = comment
        self.onDelete = onDelete
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.comment.content)
                .font(.body)
            HStack {
                Text("By: \(self.comment.user.username)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                if self.user.id == self.comment.user.id {
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
