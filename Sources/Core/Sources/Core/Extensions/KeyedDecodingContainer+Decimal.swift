//
//  KeyedDecodingContainer+Decimal.swift
//  Spendbase
//
//  Created by Yehor Myropoltsev on 02.07.2024.
//

import Foundation

public extension KeyedDecodingContainer {
    func decode(_: Decimal.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Decimal {
        let decodedValue = try self.decode(String.self, forKey: key)
        if let decimal = Decimal(string: decodedValue) {
            return decimal
        }
        throw (DecodingError.typeMismatch(
            Decimal.self,
            DecodingError.Context(
                codingPath: [key],
                debugDescription: "Failed to transform the underling string(\(decodedValue)) into Decimal"
            )
        ))
    }

    func decodeIfPresent(_: Decimal.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Decimal? {
        if let decodedValue = try self.decodeIfPresent(String.self, forKey: key), let decimal = Decimal(string: decodedValue) {
            return decimal
        }
        return nil
    }
}

public extension KeyedEncodingContainer {
    mutating func encode(_ value: Decimal, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try self.encode(value.description, forKey: key)
    }

    mutating func encodeIfPresent(_ value: Decimal?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try self.encodeIfPresent(value?.description, forKey: key)
    }
}
