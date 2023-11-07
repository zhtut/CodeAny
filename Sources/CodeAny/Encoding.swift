//
//  Encoding.swift
//  TestCodable
//
//  Created by shutut on 2023/11/7.
//

import Foundation

extension KeyedEncodingContainerProtocol where Key == JSONCodingKeys {
    
    mutating func encode(_ value: [String: Any]) throws {
        try value.forEach({ (key, value) in
            let key = JSONCodingKeys(stringValue: key)
            switch value {
            case let value as Bool:
                try encode(value, forKey: key)
            case let value as Int:
                try encode(value, forKey: key)
            case let value as Double:
                try encode(value, forKey: key)
            case let value as String:
                try encode(value, forKey: key)
            case let value as [String: Any]:
                try encode(value, forKey: key)
            case let value as [Any]:
                try encode(value, forKey: key)
            case Optional<Any>.none:
                try encodeNil(forKey: key)
            default:
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath + [key], debugDescription: "Invalid JSON value"))
            }
        })
    }
    
    mutating func encode(_ value: [String: Any]?, forKey key: Key) throws {
        if let value {
            var container = self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
            try container.encode(value)
        }
    }
    
    mutating func encode(_ value: [Any]?, forKey key: Key) throws {
        if let value {
            var container = self.nestedUnkeyedContainer(forKey: key)
            try container.encode(value)
        }
    }
    
    /// 解析任意类型
    mutating func encodeAny(_ value: Any) throws {
        switch value {
        case let value as [String: Any]:
            try encode(value)
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath, debugDescription: "Invalid JSON value"))
        }
    }
    
    /// 解析任意类型
    mutating func encodeAny(_ value: Any, forKey key: Key) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        return try container.encodeAny(value)
    }
}

/// 没有key的属性
extension UnkeyedEncodingContainer {
    mutating func encode(_ value: [Any]) throws {
        try value.enumerated().forEach({ (_, value) in
            try encodeAny(value)
        })
    }
    
    mutating func encode(_ value: [String: Any]) throws {
        var nestedContainer = self.nestedContainer(keyedBy: JSONCodingKeys.self)
        try nestedContainer.encode(value)
    }
    
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
        case let value as [String: Any]:
            try encode(value)
        case let value as [Any]:
            try encode(value)
        case Optional<Any>.none:
            try encodeNil()
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath, debugDescription: "Invalid JSON value"))
        }
    }
}
