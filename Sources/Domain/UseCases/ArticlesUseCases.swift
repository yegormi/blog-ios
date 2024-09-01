import Foundation

public protocol ArticleUseCases {
    func getArticles() async throws -> [Article]
    func getArticle(id: UUID) async throws -> Article
    func createArticle(title: String, content: String) async throws -> Article
    func updateArticle(id: UUID, title: String, content: String) async throws -> Article
    func deleteArticle(id: UUID) async throws
}
