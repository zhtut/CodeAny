import XCTest
@testable import CodeAny

final class CodeAnyTests: XCTestCase {
    
    struct Person: Codable {
        var name: String
        @AnyType
        var like: Any
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
}
