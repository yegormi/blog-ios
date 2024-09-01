//
//  File.swift
//  
//
//  Created by Yehor Myropoltsev on 01.09.2024.
//

import Foundation

public struct UserResponse: Decodable {
    let token: String
    let user: UserDTO
}
