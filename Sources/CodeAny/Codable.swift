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
    
    public func encode(to encoder: Encoder) throws {
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
    
    public func encode(to encoder: Encoder) throws {
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
