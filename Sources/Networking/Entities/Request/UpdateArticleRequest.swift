import Foundation

public struct UpdateArticleRequest: APIRequestBody {
    let title: String
    let content: String

    public init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
