//: [Previous](@previous)

import UIKit

var str = "Hello, playground"
/*
 switch
 */

/*
 没有隐式贯穿
 没有隐式贯穿
 与 C 中的 switch 语句不同，这个 switch 语句没有同时匹配 ”a” 和 ”A” 。相反它会导致一个编译时错误 case “a”:没有包含任何可执行语句 。这可以避免意外地从一个情况贯穿到另一个情况中，并且让代码更加安全和易读。
 */
//每一个情况的函数体必须包含至少一个可执行的语句。下面的代码就是不正确的，因为第一个情况是空的：
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a":
    print("a")
case "A":
    print("The letter A")
default:
    print("Not the letter A")
}

//在一个 switch 情况中匹配多个值可以用逗号分隔，并且可以写成多行，如果列表太长的话：
let anotherCharacter1: Character = "a"
switch anotherCharacter1 {
case "a", "A":
    print("The letter A")
default:
    print("Not the letter A")
}

//区间匹配
let approximateCount = 62
let countedThings = "moons orbiting Saturn111"
var naturalCount1: String = "1"
switch approximateCount {
case 0:
    naturalCount1 = "no"
case 1..<5:
    naturalCount1 = "a few"
case 5..<12:
    naturalCount1 = "several"
case 12..<100:
    naturalCount1 = "dozens of"
case 100..<1000:
    naturalCount1 = "hundreds of"
default:
    naturalCount1 = "many"
}
print("There are \(naturalCount1) \(countedThings).")

let somePoint = (1, 1)


switch somePoint {
case (0, 0):
    print("(0, 0) is at the origin")
case (_, 0):
    print("(\(somePoint.0), 0) is on the x-axis")
case (0, _):
    print("(0, \(somePoint.1)) is on the y-axis")
case (-2...2, -2...2):
    print("(\(somePoint.0), \(somePoint.1)) is inside the box")
default:
    print("(\(somePoint.0), \(somePoint.1)) is outside of the box")
}

//值绑定
let anotherPoint = (2, 0)

switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}
//Where
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}
//复合情况
let someCharacter: Character = "J"
switch someCharacter {
case "a", "e", "i", "o", "u":
    print("\(someCharacter) is a vowel")
case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
     "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
    print("\(someCharacter) is a consonant")
default:
    print("\(someCharacter) is not a vowel or a consonant")
}
// Prints "e is a vowel"
/*
 上边的 case 拥有两个模式：  (let distance, 0)  匹配 x 轴的点以及 (0, let distance) 匹配 y 轴的点。两个模式都包含一个 distance 的绑定并且 distance 在两个模式中都是整形——也就是说这个 case 函数体的代码一定可以访问 distance 的值。
 */

//控制转移语句

/*
 Continue
 continue 语句告诉循环停止正在做的事情并且再次从头开始循环的下一次遍历。它是说“我不再继续当前的循环遍历了”而不是离开整个的循环。
 
 break 语句会立即结束整个控制流语句。当你想要提前结束 switch 或者循环语句或者其他情况时可以在 switch 语句或者循环语句中使用 break 语句。
 
 Fallthrough
 Swift 中的 Switch 语句不会从每个情况的末尾贯穿到下一个情况中。相反，整个 switch 语句会在第一个匹配到的情况执行完毕之后就直接结束执行。比较而言，C 你在每一个 switch 情况末尾插入显式的 break 语句来阻止贯穿。避免默认贯穿意味着 Swift 的 switch 语句比 C 更加清晰和可预料，并且因此它们避免了意外执行多个 switch 情况。
 
  给语句打标签
 
 
 */
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1)
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
var square = 0
var diceRoll = 0
gameLoop: while square != finalSquare {
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    switch square + diceRoll {
    case finalSquare:
        // diceRoll will move us to the final square, so the game is over
        break gameLoop
    case let newSquare where newSquare > finalSquare:
        // diceRoll will move us beyond the final square, so roll again
        continue gameLoop
    default:
        // this is a valid move, so find out its effect
        square += diceRoll
        square += board[square]
    }
}
print("Game over!")
/*
 如果扔的色子将把玩家移动到最后的方格，游戏就结束。 break gameLoop 语句转移控制到 while 循环外的第一行代码上，它会结束游戏。
 
 如果扔的色子点数将会把玩家移动超过最终的方格，那么移动就是不合法的，玩家就需要再次扔色子。 continue gameLoop 语句就会结束当前的 while 循环遍历并且开始下一次循环的遍历。
 
 在其他所有的情况中，色子是合法的。玩家根据 diceRoll 的方格数前进，并且游戏的逻辑会检查蛇和梯子。然后循环结束，控制返回到 while 条件来决定是否要再次循环。
 注意
 
 如果上边的 break 语句不使用 gameLoop 标签，它就会中断 switch 语句而不是 while 语句。使用 gameLoop 标签使得要结束那个控制语句变得清晰明了。
 
 同时注意当调用 continue gameLoop 来跳入下一次循环并不是强制必须使用 gameLoop 标签的。游戏里只有一个循环，所以 continue 对谁生效是不会有歧义的。总之，配合 continue 使用 gameLoop 也无伤大雅。一直在 break 语句里写标签会让游戏的逻辑更加清晰和易读。
 */

/*
 提前退出
 guard 语句，类似于 if 语句，基于布尔值表达式来执行语句。使用 guard 语句来要求一个条件必须是真才能执行 guard 之后的语句。与 if 语句不同， guard 语句总是有一个 else 分句—— else 分句里的代码会在条件不为真的时候执行。
 */

/*
 检查api可用性
 */
if #available(iOS 10, macOS 10.12, *) {
    // Use iOS 10 APIs on iOS, and use macOS 10.12 APIs on macOS
} else {
    // Fall back to earlier iOS and macOS APIs
}

//: [Next](@next)
