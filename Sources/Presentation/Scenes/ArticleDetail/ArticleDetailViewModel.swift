import Domain
import Foundation

public class ArticleDetailViewModel: ObservableObject {
    @Published public var article: Article

    public init(article: Article) {
        self.article = article
    }
}
