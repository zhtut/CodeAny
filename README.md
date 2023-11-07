# CodeAny
用于swift codable可以支持泛型类型，对于数组里面，返回的类型不确定的时候非常有用

比如飞书的节点里面有个字段是interface的，可能是字典，或者是数组，而且这个节点中数组中，用swift的codable不太好处理
```
[{
    "field_alias": "owner",
    "field_key": "owner",
    "field_type_key": "user",
    "field_value": interface{}
}]
```

## 用法

### swift package manager

```swift
.package(name: "CodeAny", url: "https://github.com/zhtut/CodeAny.git", from: "0.1.0")
```

### Cocoapods

```ruby
pod 'CodeAny'
```

```swift
struct Person: Codable {
    var name: String
    @AnyType // 在不确定的类型属性，加上一个包装
    var like: Any
}
```

解析的方法还是一样
```swift
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
        // 使用该属性时候再判断一下类型
        if let like = three.like as? [Int] {
            print("赵六喜欢的：\(like)")
        }
        let four = persons[4]
        // 使用该属性的时候再判断一下类型
        if let like = four.like as? [String: Any] {
            print("孙七喜欢的：\(like)")
        }
        
        let jsonData = try JSONEncoder().encode(persons)
        let string = String(data: jsonData, encoding: .utf8)
        print("转换回json：\(string ?? "")")
```

### optional的 暂不支持
