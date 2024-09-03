import Foundation

public struct ServerError: Error, Decodable {
    let error: Bool
    let reason: String
}
