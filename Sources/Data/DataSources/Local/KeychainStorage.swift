import Foundation
import Security

public protocol KeychainStorageProtocol {
    func save(_ data: Data, forKey key: KeychainStorage.KeychainKey) throws
    func get(forKey key: KeychainStorage.KeychainKey) throws -> Data?
    func delete(forKey key: KeychainStorage.KeychainKey) throws
    func save(_ value: String, forKey key: KeychainStorage.KeychainKey) throws
    func getString(forKey key: KeychainStorage.KeychainKey) throws -> String?
}

public final class KeychainStorage: KeychainStorageProtocol {
    public enum KeychainKey: String {
        case authenticationToken
    }

    private let serviceName: String

    public init(serviceName: String = Bundle.main.bundleIdentifier ?? "com.yeblog.keychain") {
        self.serviceName = serviceName
    }

    // Save data to Keychain
    public func save(_ data: Data, forKey key: KeychainKey) throws {
        let query = [
            kSecAttrAccount as String: key.rawValue,
            kSecAttrService as String: self.serviceName,
            kSecClass as String: kSecClassGenericPassword,
        ] as CFDictionary

        let status = SecItemCopyMatching(query, nil)
        switch status {
        case errSecSuccess:
            // Item exists, override it.
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            let updateStatus = SecItemUpdate(query, attributesToUpdate)
            guard updateStatus == errSecSuccess else {
                throw KeychainStorageError.failedToSaveItem(updateStatus)
            }
        case errSecItemNotFound:
            // Item does not exist, create it.
            let createQuery = [
                kSecAttrAccount as String: key.rawValue,
                kSecAttrService as String: self.serviceName,
                kSecValueData as String: data,
                kSecClass as String: kSecClassGenericPassword,
            ] as CFDictionary

            let addStatus = SecItemAdd(createQuery, nil)
            guard addStatus == errSecSuccess else {
                throw KeychainStorageError.failedToSaveItem(addStatus)
            }
        default:
            throw KeychainStorageError.failedToSaveItem(status)
        }
    }

    // Retrieve data from Keychain
    public func get(forKey key: KeychainKey) throws -> Data? {
        let query = [
            kSecAttrAccount as String: key.rawValue,
            kSecClass as String: kSecClassGenericPassword,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecAttrService as String: self.serviceName,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ] as CFDictionary

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query, &result)
        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                throw KeychainStorageError.unexpectedError
            }
            return data
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainStorageError.failedToRetrieveItem(status)
        }
    }

    // Delete data from Keychain
    public func delete(forKey key: KeychainKey) throws {
        let query = [
            kSecAttrAccount as String: key.rawValue,
            kSecAttrService as String: self.serviceName,
            kSecClass as String: kSecClassGenericPassword,
        ] as CFDictionary

        let status = SecItemDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainStorageError.failedToDeleteItem(status)
        }
    }

    // Save a string to Keychain
    public func save(_ value: String, forKey key: KeychainKey) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainStorageError.dataConversionError
        }
        try self.save(data, forKey: key)
    }

    // Retrieve a string from Keychain
    public func getString(forKey key: KeychainKey) throws -> String? {
        guard let data = try get(forKey: key) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}

public enum KeychainStorageError: Error {
    case failedToSaveItem(OSStatus)
    case failedToRetrieveItem(OSStatus)
    case failedToDeleteItem(OSStatus)
    case dataConversionError
    case unexpectedError
}
