//
//  KeyedDecodingContainer+UUID.swift
//  Spendbase
//
//  Created by Yehor Myropoltsev on 02.07.2024.
//

import Foundation

public extension KeyedDecodingContainer {
    func decode(_: UUID.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UUID {
        let decodedValue = try self.decode(String.self, forKey: key)
        if let uuid = UUID(uuidString: decodedValue) {
            return uuid
        }
        throw (DecodingError.typeMismatch(
            UUID.self,
            DecodingError.Context(
                codingPath: [key],
                debugDescription: "Failed to transform the underling string(\(decodedValue)) into UUID"
            )
        ))
    }

    func decodeIfPresent(_: UUID.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UUID? {
        if let decodedValue = try self.decodeIfPresent(String.self, forKey: key), let uuid = UUID(uuidString: decodedValue) {
            return uuid
        }
        return nil
    }
}

public extension KeyedEncodingContainer {
    mutating func encode(_ value: UUID, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try self.encode(value.uuidString, forKey: key)
    }

    mutating func encodeIfPresent(_ value: UUID?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try self.encodeIfPresent(value?.uuidString, forKey: key)
    }
}
