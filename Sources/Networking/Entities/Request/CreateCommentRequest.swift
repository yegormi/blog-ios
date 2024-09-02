import Foundation

public struct CreateCommentRequest: APIRequestBody {
    let content: String

    public init(content: String) {
        self.content = content
    }
}
