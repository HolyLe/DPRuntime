//: [Previous](@previous)

import Foundation

var str = "Hello, playground"
/*
 Int
 
 在大多数情况下，你不需要在你的代码中为整数设置一个特定的长度。Swift 提供了一个额外的整数类型： Int ，它拥有与当前平台的原生字相同的长度。
 
 在32位平台上， Int 的长度和 Int32 相同。
 在64位平台上， Int 的长度和 Int64 相同。
 除非你需操作特定长度的整数，否则请尽量在代码中使用 Int 作为你的整数的值类型。这样能提高代码的统一性和兼容性，即使在 32 位的平台上， Int 也可以存 -2,147,483,648 到 2,147,483,647 之间的任意值，对于大多数整数区间来说完全够用了。
 
 
 UInt
 Swift 也提供了一种无符号的整数类型， UInt ，它和当前平台的原生字长度相同。
 
 在32位平台上， UInt 长度和 UInt32 长度相同。
 在64位平台上， UInt 长度和 UInt64 长度相同。
 注意
 只在的确需要存储一个和当前平台原生字长度相同的无符号整数的时候才使用 UInt 。其他情况下，推荐使用 Int ，即使已经知道存储的值都是非负的。如同类型安全和类型推断中描述的那样，统一使用 Int  会提高代码的兼容性，同时可以避免不同数字类型之间的转换问题，也符合整数的类型推断。
 
 浮点数
 浮点数是有小数的数字，比如 3.14159 , 0.1 , 和 -273.15 。
 浮点类型相比整数类型来说能表示更大范围的值，可以存储比 Int 类型更大或者更小的数字。Swift 提供了两种有符号的浮点数类型。
 
 Double代表 64 位的浮点数。
 Float 代表 32 位的浮点数。
 注意
 Double 有至少 15 位数字的精度，而 Float 的精度只有 6 位。具体使用哪种浮点类型取决于你代码需要处理的值范围。在两种类型都可以的情况下，推荐使用 Double 类型。
 */

/*
 整数型字面量可以写作：
 
 一个十进制数，没有前缀
 一个二进制数，前缀是 0b
 一个八进制数，前缀是 0o
 一个十六进制数，前缀是 0x
 
 
 十进制数与 exp  的指数，结果就等于基数乘以 10exp：
 
 1.25e2 意味着 1.25 x 102, 或者 125.0  .
 1.25e-2  意味着 1.25 x 10-2, 或者 0.0125  .
 十六进制数与 exp 指数，结果就等于基数乘以2exp：
 
 0xFp2  意味着 15 x 22, 或者 60.0 .
 0xFp-2  意味着 15 x 2-2, 或者 3.75 .
 
 1
 2
 3
 let decimalDouble = 12.1875
 let exponentDouble = 1.21875e1
 let hexadecimalDouble = 0xC.3p0
 */
let min = UInt8.min
let max = UInt8.max
let justOverOneMillion = 1_000_000.000_000_1
print(min)
print(max)
print(justOverOneMillion)
let three = 3
let pointOneFourOn = 0.14159

/// 注意需要转换
let pi = Double(three) + pointOneFourOn

let a = Int(pi)


/*
 元组
 */
let http = (404, "Not Found")

let (status, statusMessage) = http
print("The status message is \(statusMessage)")
print("The status message is \(status)")
let (jstTheStatusCode,_) = http
print("The status message is \(jstTheStatusCode)")

print("The status code is \(http.0)")

//你可以在定义元组的时候给其中的单个元素命名：
let http200Status = (statusCode: 200, description: "OK")


/*
 可选项
 
 可选的 Int 写做 Int? ，而不是 Int 。问号明确了它储存的值是一个可选项，意思就是说它可能包含某些 Int  值，或者可能根本不包含值。（他不能包含其他的值，例如 Bool 值或者 String 值。它要么是 Int 要么什么都没有。）
 
 
 */

let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)

//nil
//你可以通过给可选变量赋值一个 nil 来将之设置为没有值：


var serverResponseCode: Int? = 404
// serverResponseCode contains an actual Int value of 404
serverResponseCode = nil
// serverResponseCode now contains no value
//注意

//nil 不能用于非可选的常量或者变量，如果你的代码中变量或常量需要作用于特定条件下的值缺失，可以给他声明为相应类型的可选项。
//
//如果你定义的可选变量没有提供一个默认值，变量会被自动设置成 nil 。


var surveyAnswer: String?
// surveyAnswer is automatically set to nil


/*注意
 
 Swift 中的 nil 和Objective-C 中的 nil 不同，在 Objective-C 中 nil 是一个指向不存在对象的指针。在 Swift中， nil 不是指针，他是值缺失的一种特殊类型，任何类型的可选项都可以设置成 nil 而不仅仅是对象类型。
 */

//一旦你确定可选中包含值，你可以在可选的名字后面加一个感叹号 （ ! ） 来获取值，感叹号的意思就是说“我知道这个可选项里边有值，展开吧。”这就是所谓的可选值的强制展开。
if convertedNumber != nil {
    print("convertedNumber has an integer value of \(convertedNumber!).")
}

let quotation = """
   The White Rabbit put on his spectacles.  "Where shall I begin,
   please your Majesty?" he asked.
   "Begin at the beginning," the King said gravely, "and go on
   till you come to the end; then stop."
   """
print(quotation)
//: [Next](@next)
