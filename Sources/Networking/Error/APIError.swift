import Foundation

public enum APIError: LocalizedError {
    case decodingError(Error)
    case invalidResponse
    case networkError(Error)
    case serverError(ServerError)

    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            NSLocalizedString(
                "The server returned an invalid response.",
                comment: "Invalid server response error"
            )
        case let .networkError(underlyingError):
            NSLocalizedString(
                "A network error occurred: \(underlyingError.localizedDescription)",
                comment: "Network error"
            )
        case let .decodingError(underlyingError):
            NSLocalizedString(
                "Failed to process the server response: \(underlyingError.localizedDescription)",
                comment: "JSON decoding error"
            )
        case let .serverError(error):
            NSLocalizedString(
                "\(error.reason)",
                comment: "Server error with message reason"
            )
        }
    }

    public var failureReason: String? {
        switch self {
        case .invalidResponse:
            NSLocalizedString(
                "The server's response was not in the expected format.",
                comment: "Invalid response failure reason"
            )
        case .networkError:
            NSLocalizedString(
                "There was a problem with the network connection.",
                comment: "Network error failure reason"
            )
        case .decodingError:
            NSLocalizedString(
                "The app couldn't understand the server's response.",
                comment: "Decoding error failure reason"
            )
        case .serverError:
            NSLocalizedString(
                "The server encountered an error while processing the request.",
                comment: "Server error failure reason"
            )
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .invalidResponse, .serverError:
            NSLocalizedString(
                "Please try again later or contact support if the problem persists.",
                comment: "Recovery suggestion for server errors"
            )
        case .networkError:
            NSLocalizedString(
                "Please check your internet connection and try again.",
                comment: "Recovery suggestion for network errors"
            )
        case .decodingError:
            NSLocalizedString(
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
            apiError
        case is DecodingError:
            .decodingError(error)
        default:
            .networkError(error)
        }
    }
}
