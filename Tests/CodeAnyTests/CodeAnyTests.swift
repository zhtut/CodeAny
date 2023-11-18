import XCTest
@testable import CodeAny

final class CodeAnyTests: XCTestCase {
    
    struct Boll: Codable {
        var size: Int
    }
    
    struct Person: Codable {
        var name: String
        @AnyType
        var like: Any
    }
    
    func testEncodeModel() async throws {
        let person = Person(name: "hahaha", like: Boll(size: 10))
        let data = try JSONEncoder().encode(person)
        let json = try JSONSerialization.jsonObject(with: data)
        guard let dict = json as? [String: Any],
              let boll = dict["like"] as? [String: Any],
              let size = boll["size"] as? Int else {
            XCTAssert(false)
            return
        }
        XCTAssert(size == 10)
        print("like\(person.like)")
    }
    
    func testExample() async throws {
        let jsons = [
            [
                "name": "张三",
                "like": "吃饭",
                "company": "apple"
            ],
            [
                "name": "李四",
                "like": 5,
                "company": "google"
            ],
            [
                "name": "王五",
                "like": 15.5,
                "age": 18
            ],
            [
                "name": "赵六",
                "like": [5]
            ],
            [
                "name": "孙七",
                "like": ["test": true]
            ],
            [
                "name": "刘八",
                "like": "<null>"
            ]
        ]
        
        let data = try JSONSerialization.data(withJSONObject: jsons)
        let persons = try JSONDecoder().decode([Person].self, from: data)
        print("解析成功：\(persons)")
        print("他们喜欢的东西：\(persons.map({$0.like}))")
        
        let three = persons[3]
        if let like = three.like as? [Int] {
            print("赵六喜欢的：\(like)")
        }
        let four = persons[4]
        if let like = four.like as? [String: Any] {
            print("孙七喜欢的：\(like)")
        }
        
        let jsonData = try JSONEncoder().encode(persons)
        let string = String(data: jsonData, encoding: .utf8)
        print("转换回来的：\(string ?? "")")
    }
    
    struct Person2: Codable {
        var name: String
        @OptionalAnyType
        var like: Any?
    }
    
    func testSimple() throws {
        let jsonStr = """
                    {
                        "like": { "phone": "Apple" }
                    }
                """
        try testCode(jsonStr, model: Person2.self)
    }
    
    func testOptionalExample() throws {
        let jsonStr = """
        [
            {
                "name": "张三",
                "like": "吃饭"
            },
            {
                "name": "李四",
                "like": null
            },
            {
                "name": "王五",
                "like": 5
            },
            {
                "name": "李六",
                "like": { "phone": "Apple" }
            },
            {
                "name": "赵七",
                "like": ["a", "b", 1]
            }
        ]
        """
        try testCode(jsonStr, model: [Person2].self)
    }
    
    func testCode(_ jsonStr: String, model: Codable.Type) throws {
        // 生成有序列的固定字符串，方便后面对比
        let jsonData = jsonStr.data(using: .utf8)!
        
        // 生成模型
        let model = try JSONDecoder().decode(model.self, from: jsonData)
        
        // 通过模型生成json
        let modelData = try JSONEncoder().encode(model)
        
        let originJsonStr = jsonData.sortJsonStr
        let modelJsonStr = modelData.sortJsonStr
        
        XCTAssert(originJsonStr == modelJsonStr, "生成之后不相等了, origin:\(originJsonStr ?? ""), model: \(modelJsonStr ?? "")")
        
        print("生成之后相等")
    }
}

extension Data {
    var sortJsonStr: String? {
        guard let dict = try? JSONSerialization.jsonObject(with: self),
              let sortJsonData = try? JSONSerialization.data(withJSONObject: dict, options: [.sortedKeys, .prettyPrinted]) else {
            return nil
        }
        
        let sortJsonStr = String(data: sortJsonData, encoding: .utf8)
        return sortJsonStr
    }
}
