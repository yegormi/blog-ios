import Foundation

public struct UserResponse: Decodable {
    let token: String
    let user: UserDTO
}
