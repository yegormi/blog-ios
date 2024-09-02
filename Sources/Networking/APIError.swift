import Foundation

public enum APIError: LocalizedError {
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case serverError(String)

    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return NSLocalizedString(
                "The server returned an invalid response.",
                comment: "Invalid server response error"
            )
        case .networkError(let underlyingError):
            return NSLocalizedString(
                "A network error occurred: \(underlyingError.localizedDescription)",
                comment: "Network error"
            )
        case .decodingError(let underlyingError):
            return NSLocalizedString(
                "Failed to process the server response: \(underlyingError.localizedDescription)",
                comment: "JSON decoding error"
            )
        case .serverError(let message):
            return NSLocalizedString(
                "Server error: \(message)",
                comment: "Server error with message"
            )
        }
    }

    public var failureReason: String? {
        switch self {
        case .invalidResponse:
            return NSLocalizedString(
                "The server's response was not in the expected format.",
                comment: "Invalid response failure reason"
            )
        case .networkError:
            return NSLocalizedString(
                "There was a problem with the network connection.",
                comment: "Network error failure reason"
            )
        case .decodingError:
            return NSLocalizedString(
                "The app couldn't understand the server's response.",
                comment: "Decoding error failure reason"
            )
        case .serverError:
            return NSLocalizedString(
                "The server encountered an error while processing the request.",
                comment: "Server error failure reason"
            )
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .invalidResponse, .serverError:
            return NSLocalizedString(
                "Please try again later or contact support if the problem persists.",
                comment: "Recovery suggestion for server errors"
            )
        case .networkError:
            return NSLocalizedString(
                "Please check your internet connection and try again.",
                comment: "Recovery suggestion for network errors"
            )
        case .decodingError:
            return NSLocalizedString(
                "Please update the app to the latest version or contact support.",
                comment: "Recovery suggestion for decoding errors"
            )
        }
    }
}

extension APIError {
    static func from(_ error: Error) -> APIError {
        switch error {
        case let apiError as APIError:
            return apiError
        case is DecodingError:
            return .decodingError(error)
        default:
            return .networkError(error)
        }
    }
}
