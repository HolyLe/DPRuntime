//: Playground - noun: a place where people can play

import UIKit

/*
 数组
 */
//创建
var someInts = [Int]()
someInts = [] //数组类型仍是Int类型
someInts.append(1)
var threeDoubles = Array(repeating: 0.0, count: 3)

//链接数组
var anotherThreeDoubles = Array(repeating: 1.0, count: 3)

var sixDoubles = threeDoubles + anotherThreeDoubles


//字面量创建数组
var shopping = ["eggs", "Milk"]

var shopping1 : [String] = ["eggs", "Milk"] //swfit可以自行判断

//判空
if shopping.isEmpty{
    print("The shopping list is empty.")
}else{
    print("The shopping list is not empty.")
}
//添加
shopping.append("222")

shopping += ["aaa"]

shopping += ["aaa", "bbb", "ccc"]

var firstItem = shopping[0]

firstItem = "222"

print(shopping)

shopping[0] = "six eggs"

print(shopping)

shopping[4...6] = ["Bananas", "Apples"]

print(shopping)

let apples = shopping.removeLast()

let mapleSyrup = shopping.remove(at: 0)

shopping.insert("Maple Syrup", at: 0)

shopping.count
//遍历
for (index, value) in shopping.enumerated() {
    print("Iten \(index) : \(value)")
}
/*
 为了能让类型储存在合集当中，它必须是可哈希的——就是说类型必须提供计算它自身哈希值的方法。哈希值是Int值且所有的对比起来相等的对象都相同，比如 a == b，它遵循 a.hashValue == b.hashValue。
 
 所有 Swift 的基础类型（比如 String, Int, Double, 和 Bool）默认都是可哈希的，并且可以用于合集或者字典的键。没有关联值的枚举成员值（如同枚举当中描述的那样）同样默认可哈希。
 
 注意
 
 你可以使用你自己自定义的类型作为合集的值类型或者字典的键类型，只要让它们遵循 Swift 基础库的 Hashable协议即可。遵循 Hashable协议的类型必须提供可获取的叫做 hashValue的 Int属性。通过 hashValue属性返回的值不需要在同一个程序的不同的执行当中都相同，或者不同程序。
 
 因为 Hashable协议遵循 Equatable，遵循的类型必须同时一个“等于”运算符 ( ==)的实现。 Equatable协议需要任何遵循 ==的实现都具有等价关系。就是说， ==的实现必须满足以下三个条件，其中 a, b, 和 c是任意值：
 
 a == a  (自反性)
 a == b 意味着 b == a  (对称性)
 a == b && b == c 意味着 a == c  (传递性)
 更多对协议的遵循信息，见协议。
 */
//创建
var letters = Set <Character>()

letters.insert("a")



letters = []

var favoriteGenres : Set <String> = ["Rock", "Classical", "Hip hop"]

var favoriteGenres1 : Set = ["Rock", "Classical", "Hip hop"]

favoriteGenres.count

if favoriteGenres.isEmpty{
     print("As far as music goes, I'm not picky.")
}else{
    print("I have particular music preferences.")
}

favoriteGenres.insert("a")

print(favoriteGenres)

if let removedGenre = favoriteGenres.remove("Rock") {
    print("\(removedGenre)? I'm over it.")
} else {
    print("I never much cared for that.")
}

if let removedGenre = favoriteGenres.remove("Rock") {
    print("\(removedGenre)? I'm over it.")
} else {
    print("I never much cared for that.")
}

//遍历
for genre in favoriteGenres {
    print("\(genre)")
}

for genre in favoriteGenres.sorted() {
    print("\(genre)")
}
/*
 使用 intersection(_:)方法来创建一个只包含两个合集共有值的新合集；
 使用 symmetricDifference(_:)方法来创建一个只包含两个合集各自有的非共有值的新合集；
 使用 union(_:)方法来创建一个包含两个合集所有值的新合集；
 使用 subtracting(_:)方法来创建一个两个合集当中不包含某个合集值的新合集。
 */

let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

oddDigits.union(evenDigits).sorted()
// [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
oddDigits.intersection(evenDigits).sorted()
// []
oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
// [1, 9]
oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()
// [1, 2, 9]
/*
 使用“相等”运算符 ( == )来判断两个合集是否包含有相同的值；
 使用 isSubset(of:) 方法来确定一个合集的所有值是被某合集包含；
 使用 isSuperset(of:)方法来确定一个合集是否包含某个合集的所有值；
 使用 isStrictSubset(of:) 或者 isStrictSuperset(of:)方法来确定是个合集是否为某一个合集的子集或者超集，但并不相等；
 使用 isDisjoint(with:)方法来判断两个合集是否拥有完全不同的值。
 */

let houseAnimals: Set = ["?", "?"]
let farmAnimals: Set = ["?", "?", "?", "?", "?"]
let cityAnimals: Set = ["?", "?"]

houseAnimals.isSubset(of: farmAnimals)
// true
farmAnimals.isSuperset(of: houseAnimals)
// true
farmAnimals.isDisjoint(with: cityAnimals)
// true

//字典
//创建

var namesOfIntegers = [Int : String]()

namesOfIntegers[16] = "sixteen"

namesOfIntegers = [:]
// namesOfIntegers is once again an empty dictionary of type [Int: String]

//字面量创建
var airports : [String : String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

airports.count

if airports.isEmpty {
    print("The airports dictionary is empty.")
} else {
    print("The airports dictionary is not empty.")
}
airports["LHR"] = "London Heathrow"
/*
 作为下标脚本的代替，使用字典的 updateValue(_:forKey:)方法来设置或者更新特点键的值。就像上边下标脚本的栗子， updateValue(_:forKey:)方法会在键没有值的时候设置一个值，或者在键已经存在的时候更新它。总之，不同于下标脚本， updateValue(_:forKey:)方法在执行更新之后返回旧的值。这允许你检查更新是否成功。
 updateValue(_:forKey:)方法返回一个字典值类型的可选项值。比如对于储存 String值的字典来说，方法会返回 String?类型的值，或者说“可选的 String”。这个可选项包含了键的旧值如果更新前存在的话，否则就是 nil：
 */
if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
}
/*
 你同样可以使用下标脚本语法来从字典的特点键中取回值。由于可能请求的键没有值，字典的下标脚本返回可选的字典值类型。如果字典包含了请求的键的值，下标脚本就返回一个包含这个键的值的可选项。否则，下标脚本返回 nil
 */
if let airportName = airports["DUB"] {
    print("The name of the airport is \(airportName).")
} else {
    print("That airport is not in the airports dictionary.")
}
/*
 你可以使用下标脚本语法给一个键赋值 nil来从字典当中移除一个键值对：
 */
airports["APL"] = "Apple International"
// "Apple International" is not the real airport for APL, so delete it
airports["APL"] = nil
// APL has now been removed from the dictionary
/*
 另外，使用 removeValue(forKey:)来从字典里移除键值对。这个方法移除键值对如果他们存在的话，并且返回移除的值，如果值不存在则返回 nil：
 */
if let removedValue = airports.removeValue(forKey: "DUB") {
    print("The removed airport's name is \(removedValue).")
} else {
    print("The airports dictionary does not contain a value for DUB.")
}

//遍历字典
for (airportCode, airportName) in airports {
    print("\(airportCode): \(airportName)")
}
//用 keys或 values属性来初始化一个新数组
let airportCodes = [String](airports.keys)
// airportCodes is ["YYZ", "LHR"]
let airportNames = [String](airports.values)
