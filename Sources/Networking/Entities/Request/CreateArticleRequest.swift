import Foundation

public struct CreateArticleRequest: APIRequestBody {
    let title: String
    let content: String

    public init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
