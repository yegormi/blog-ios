import Foundation

public final class TokenManager {
    private let userDefaults: UserDefaults
    private let tokenKey = "authToken"

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func saveToken(_ token: String) {
        userDefaults.set(token, forKey: tokenKey)
    }

    public func getToken() -> String? {
        return userDefaults.string(forKey: tokenKey)
    }

    public func deleteToken() {
        userDefaults.removeObject(forKey: tokenKey)
    }
}
