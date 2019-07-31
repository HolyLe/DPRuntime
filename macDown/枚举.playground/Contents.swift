//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 枚举
 枚举为一组相关值定义了一个通用类型，从而可以让你在代码中类型安全地操作这些值。
 
 如果你熟悉 C ，那么你可能知道 C 中的枚举会给一组整数值分配相关的名称。Swift 中的枚举则更加灵活，并且不需给枚举中的每一个成员都提供值。如果一个值（所谓“原始”值）要被提供给每一个枚举成员，那么这个值可以是字符串、字符、任意的整数值，或者是浮点类型。
 
 而且，枚举成员可以指定任意类型的值来与不同的成员值关联储存，这更像是其他语言中的 union 或variant 的效果。你可以定义一组相关成员的合集作为枚举的一部分，每一个成员都可以有不同类型的值的合集与其关联。
 
 Swift 中的枚举是具有自己权限的一类类型。它们使用了许多一般只被类所支持的特性，例如计算属性用来提供关于枚举当前值的额外信息，并且实例方法用来提供与枚举表示的值相关的功能。枚举同样也能够定义初始化器来初始化成员值；而且能够遵循协议来提供标准功能。
 */


//1.枚举语法

enum CompassPoint {
    case north
    case south
    case east
    case west
}
//不像 C 和 Objective-C 那样，Swift 的枚举成员在被创建时不会分配一个默认的整数值。在上文的 CompassPoint例子中， north， south， east和 west并不代表 0， 1， 2和 3。而相反，不同的枚举成员在它们自己的权限中都是完全合格的值，并且是一个在 CompassPoint中被显式定义的类型。
//多个成员值可以出现在同一行中，要用逗号隔开：
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

var directionToHead = CompassPoint.west

directionToHead = .east

//directionToHead的类型是已知的，所以当设定它的值时你可以不用写类型。这样做可以使得你在操作确定类型的枚举时让代码非常易读。
/*
 使用 Switch 语句来匹配枚举值
 */


directionToHead = .south
switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}
//就像在控制流中所描述的那样，当判断一个枚举成员时， switch语句应该是全覆盖的。如果 .west的 case被省略了，那么代码将不能编译，因为这时表明它并没有覆盖 CompassPoint的所有成员。要求覆盖所有枚举成员是因为这样可以保证枚举成员不会意外的被漏掉。
//如果不能为所有枚举成员都提供一个 case，那你也可以提供一个 default情况来包含那些不能被明确写出的成员：


let somePlanet = Planet.venus
switch somePlanet {
case .earth:
    print("Mostly harmless")
default:
    print("Not a safe place for humans")
}


//遍历枚举情况（case）

enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) Beverage count")

for beverage in Beverage.allCases {
    print(beverage)
}
/*
 关联值
 假设库存跟踪系统需要按两个不同类型的条形码跟踪产品，一些产品贴的是用数字 0~9 的 UPC-A 格式一维条形码。每一个条码数字都含有一个“数字系统”位，之后是五个“制造商代码”数字和五个“产品代码”数字。而最后则是一个“检测”位来验证代码已经被正确扫描：
 在 Swift 中，为不同类型产品条码定义枚举大概是这种姿势：
 */
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

//定义一个叫做 Barcode的枚举类型，它要么用 (Int, Int, Int, Int)类型的关联值获取 upc 值，要么用 String 类型的关联值获取一个 qrCode的值
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
//最初的 Barcode.upc和它的整数值将被新的 Barcode.qrCode和它的字符串值代替。 Barcode类型的常量和变量可以存储一个 .upc或一个 .qrCode（和它们的相关值一起存储）中的任意一个，但是它们只可以在给定的时间内存储它们它们其中之一。
switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
//如果对于一个枚举成员的所有的相关值都被提取为常量，或如果都被提取为变量，为了简洁，你可以用一个单独的 var或 let在成员名称前标注：


switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC : \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode).")
}
// Prints "QR code: ABCDEFGHIJKLMNOP."

/*原始值
  关联值中条形码的栗子展示了枚举成员是如何声明它们存储不同类型的相关值的。作为相关值的另一种选择，枚举成员可以用相同类型的默认值预先填充（称为原始值）。
 */

enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

//这里，一个叫做 ASCIIControlCharacter的枚举原始值被定义为类型 Character，并且被放置在了更多的一些 ASCII 控制字符中， Character值的描述见字符串和字符。原始值与关联值不同。原始值是当你第一次定义枚举的时候，它们用来预先填充的值，正如上面的三个 ASCII 码。
//特定枚举成员的原始值是始终相同的。关联值在你基于枚举成员的其中之一创建新的常量或变量时设定，并且在你每次这么做的时候这些关联值可以是不同的。
/*
 隐式指定的原始值
 当你在操作存储整数或字符串原始值枚举的时候，你不必显式地给每一个成员都分配一个原始值。当你没有分配时，Swift 将会自动为你分配值。
 
 实际上，当整数值被用于作为原始值时，每成员的隐式值都比前一个大一。如果第一个成员没有值，那么它的值是 0 。
 

 */
enum Planet1: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
enum CompassPoint1: String {
    case north, south, east, west
}
//在上面的例子中， CompassPoint.south有一个隐式原始值 "south" ，以此类推。
//你可以用 rawValue属性来访问一个枚举成员的原始值
let earthsOrder = Planet1.earth.rawValue
let sunsetDirection = CompassPoint1.west.rawValue
//从原始值初始化
//如果你用原始值类型来定义一个枚举，那么枚举就会自动收到一个可以接受原始值类型的值的初始化器（叫做 rawValue的形式参数）然后返回一个枚举成员或者 nil 。你可以使用这个初始化器来尝试创建一个枚举的新实例。
//let possiblePlanet = Planet1(rawValue: 7)
//print(possiblePlanet)//总之，不是所有可能的 Int值都会对应一个行星。因此原始值的初始化器总是返回可选的枚举成员。在上面的例子中， possiblePlanet的类型是 Planet? ，或者“可选项 Planet”
let positionToFind = 11
if let somePlanet = Planet1(rawValue: positionToFind) {
    switch somePlanet {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
} else {
    print("There isn't a planet at position \(positionToFind)")
}
/*
 递归枚举
 
 数学表达式的一大特征就是它们可以内嵌。比如说表达式(5 + 4) * 2 在乘法右手侧有一个数但其他表达式在乘法的左手侧。因为数据被内嵌了，用来储存数据的枚举同样需要支持内嵌——这意味着枚举需要被递归。
 
 递归枚举是拥有另一个枚举作为枚举成员关联值的枚举。当编译器操作递归枚举时必须插入间接寻址层。你可以在声明枚举成员之前使用 indirect关键字来明确它是递归的。
 */
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
indirect enum ArithmeticExpression1 {
    case number(Int)
    case addition(ArithmeticExpression1, ArithmeticExpression1)
    case multiplication(ArithmeticExpression1, ArithmeticExpression1)
}
/*
 这个枚举可以储存三种数学运算表达式：单一的数字，两个两个表达式的加法，以及两个表达式的乘法。 addition 和 multiplication 成员拥有同样是数学表达式的关联值——这些关联值让嵌套表达式成为可能。比如说，表达式 (5 + 4) * 2 乘号右侧有一个数字左侧有其他表达式。由于数据是内嵌的，用来储存数据的枚举同样需要支持内嵌——这就是说枚举需要递归。下边的代码展示了为 (5 + 4) * 2 创建的递归枚举 ArithmeticExpression ：
 */


let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}

print(evaluate(five))
