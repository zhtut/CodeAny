//
//  Decoding.swift
//  TestCodable
//
//  Created by shutut on 2023/11/7.
//

import Foundation

extension KeyedDecodingContainer {
    
    func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }
    
    func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }
    
    func decodeAny(_ type: Any.Type, forKey key: K) throws -> Any {
        if let value = try? decode(Bool.self, forKey: key) {
            return value
        } else if let value = try? decode(Int.self, forKey: key) {
            return value
        } else if let value = try? decode(Double.self, forKey: key) {
            return value
        } else if let value = try? decode(String.self, forKey: key) {
            return value
        } else if let value = try? decode([String: Any].self, forKey: key) {
            return value
        } else if let value = try? decode([Any].self, forKey: key) {
            return value
        } else if let value = try? decodeNil(forKey: key) {
            return value
        }
        throw DecodingError.valueNotFound(type, .init(codingPath: [key], debugDescription: "valueNotFound \(type)"))
    }
    
    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()
        for key in allKeys {
            if let value = try? decodeAny(Any.self, forKey: key) {
                dictionary[key.stringValue] = value
            }
        }
        return dictionary
    }
}

/// 没有key的json节点
extension UnkeyedDecodingContainer {
    
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []
        while isAtEnd == false {
            if let value = try? decodeAny(Any.self) {
                array.append(value)
            }
        }
        return array
    }
    
    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
    
    mutating func decodeAny(_ type: Any.Type) throws -> Any {
        if let value = try? decode(Bool.self) {
            return value
        } else if let value = try? decode(Int.self) {
            return value
        } else if let value = try? decode(Double.self) {
            return value
        } else if let value = try? decode(String.self) {
            return value
        } else if let value = try? decode([String: Any].self) {
            return value
        } else if let value = try? decode([Any].self) {
            return value
        } else if let value = try? decodeNil() {
            return value
        }
        throw DecodingError.valueNotFound(type, .init(codingPath: codingPath, debugDescription: "valueNotFound \(type)"))
    }
}
