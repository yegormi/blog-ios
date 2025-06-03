import Foundation

/// API Error data transfer object
public struct APIErrorDTO: Error, Decodable {
    /// HTTP status code of the error
    public let status: Int
    /// Error type or category
    public let error: String
    /// Detailed error message
    public let message: String
    /// API path where the error occurred
    public let path: String
    /// When the error occurred (ISO8601 format)
    public let timestamp: String

    public init(
        status: Int,
        error: String,
        message: String,
        path: String,
        timestamp: String
    ) {
        self.status = status
        self.error = error
        self.message = message
        self.path = path
        self.timestamp = timestamp
    }
}
