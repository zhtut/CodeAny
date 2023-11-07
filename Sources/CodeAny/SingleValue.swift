//
//  SingleValue.swift
//  TestCodable
//
//  Created by shutut on 2023/11/7.
//

import Foundation

extension SingleValueDecodingContainer {
    /// 解析单个value
    mutating func decodeAny(_ type: Any.Type) throws -> Any? {
        if let value = try? decode(Bool.self) {
            return value
        } else if let value = try? decode(Int.self) {
            return value
        } else if let value = try? decode(Double.self) {
            return value
        } else if let value = try? decode(String.self) {
            return value
        }
        return nil
    }
}

extension SingleValueEncodingContainer {
    /// 解析单个value
    mutating func encodeAny(_ value: Any) throws {
        switch value {
        case let value as Bool:
            try encode(value)
        case let value as Int:
            try encode(value)
        case let value as Double:
            try encode(value)
        case let value as String:
            try encode(value)
        case Optional<Any>.none:
            try encodeNil()
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath, debugDescription: "Invalid JSON value"))
        }
    }
}
