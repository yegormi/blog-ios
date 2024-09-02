import Foundation

public final class TokenManager {
    private let userDefaults: UserDefaults
    private let tokenKey = "authToken"

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func saveToken(_ token: String) {
        self.userDefaults.set(token, forKey: self.tokenKey)
    }

    public func getToken() -> String? {
        self.userDefaults.string(forKey: self.tokenKey)
    }

    public func deleteToken() {
        self.userDefaults.removeObject(forKey: self.tokenKey)
    }
}
