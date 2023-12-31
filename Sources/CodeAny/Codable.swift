//
//  File.swift
//  
//
//  Created by shutut on 2023/11/6.
//

import Foundation

struct JSONCodingKeys: CodingKey {
    var stringValue: String
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

/// 不确定的类型
@propertyWrapper
public final class AnyType: Codable {
    public var wrappedValue: Any
    
    public init(wrappedValue: Any) {
        self.wrappedValue = wrappedValue
    }
    
    public func encode(to encoder: Encoder) throws {
        // 如果是json字符串，需要先解成对应的字典或者数组，再去encode
        if let codeValue = wrappedValue as? Encodable,
           JSONSerialization.isValidJSONObject(wrappedValue) {
            let data = try JSONEncoder().encode(codeValue)
            wrappedValue = try JSONSerialization.jsonObject(with: data)
        }
        do {
            var single = encoder.singleValueContainer()
            try single.encodeAny(wrappedValue)
        } catch {
            if let dict = wrappedValue as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKeys.self)
                try container.encode(dict)
            } else {
                var container = encoder.unkeyedContainer()
                try container.encodeAny(wrappedValue)
            }
        }
    }
    
    public init(from decoder: Decoder) throws {
        if var container = try? decoder.singleValueContainer(),
            let value = try? container.decodeAny(Any.self) {
            self.wrappedValue = value
        } else if var container = try? decoder.unkeyedContainer(),
                  let value = try? container.decode([Any].self) {
            self.wrappedValue = value
        } else {
            let container = try decoder.container(keyedBy: JSONCodingKeys.self)
            self.wrappedValue = try container.decode([String: Any].self)
        }
    }
}


/// 不确定的optional类型，暂不支持
@propertyWrapper
public final class OptionalAnyType: Codable {
    public var wrappedValue: Any?
    
    public init(wrappedValue: Any?) {
        self.wrappedValue = wrappedValue
    }
    
    public func encode(to encoder: Encoder) throws {
        // 如果是json字符串，需要先解成对应的字典或者数组，再去encode
        if let codeValue = wrappedValue as? Encodable,
           JSONSerialization.isValidJSONObject(wrappedValue) {
            let data = try JSONEncoder().encode(codeValue)
            wrappedValue = try JSONSerialization.jsonObject(with: data)
        }
        do {
            var single = encoder.singleValueContainer()
            try single.encodeAny(wrappedValue)
        } catch {
            if let dict = wrappedValue as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKeys.self)
                try container.encode(dict)
            } else {
                var container = encoder.unkeyedContainer()
                try container.encodeAny(wrappedValue)
            }
        }
    }
    
    public init(from decoder: Decoder) throws {
        if var container = try? decoder.singleValueContainer(),
           let value = try? container.decodeAny(Any.self) {
            self.wrappedValue = value
        } else if var container = try? decoder.unkeyedContainer(),
                  let value = try? container.decode([Any].self) {
            self.wrappedValue = value
        } else if let container = try? decoder.container(keyedBy: JSONCodingKeys.self),
                  let value = try? container.decode([String: Any].self) {
            self.wrappedValue = value
        }
    }
}
