import UIKit

var str = "Hello, playground"
//for-in

let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
    print("Hello, \(name)!")
}

let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (animalName, legCount) in numberOfLegs {
    print("\(animalName)s have \(legCount) legs")
}

for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}
//如果你不需要序列的每一个值，你可以使用下划线来取代遍历名以忽略值。
let base = 3
let power = 10
var answer = 1
for _ in 1...power {
    answer *= base
}
print("\(base) to the power of \(power) is \(answer)")

let minutes = 60
for tickMark in 0..<minutes {
    // render the tick mark each minute (60 times)
    print(tickMark)
}
//有些用户可能想要在他们的UI上少来点分钟标记。比如说每 5 分钟一个标记吧。使用 stride(from:to:by:) 函数来跳过不想要的标记。
let minuteInterval = 5
for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
    // render the tick mark every 5 minutes (0, 5, 10, 15 ... 45, 50, 55)
    print(tickMark)
}
//闭区间也同样适用，使用 stride(from:through:by:) 即可：
let hours = 12
let hourInterval = 3
for tickMark in stride(from: 3, through: hours, by: hourInterval) {
    // render the tick mark every 3 hours (3, 6, 9, 12)
    print(tickMark)
}

/*
 while
 
 while 在每次循环开始的时候计算它自己的条件；
 repeat-while 在每次循环结束的时候计算它自己的条件。
 
 */

//while
let count = 25

var array = [Int](repeating: 0, count: count + 1);

array[3] = +8; array[6] = +11; array[9] = +9; array[10] = +2;
array[14] = -10; array[19] = -11; array[22] = -2; array[24] = -8;


//var square = 0
//var diceRoll = 0
//while square < count {
//    // roll the dice
//    diceRoll = Int((arc4random() % 6) + 1);
//
//    // move by the rolled amount
//    square += diceRoll
//
//    if square < array.count {
//        // if we're still on the board, move up or down for a snake or a ladder
//        square += array[square]
//    }
//}
//print("Game over!")

//repeat-while
/*
 while 循环的另一种形式，就是所谓的 repeat-while 循环，在判断循环条件之前会执行一次循环代码块。然后会继续重复循环直到条件为 false 。
 注意
 
 Swift 的 repeat-while 循环是与其他语言中的 do-while 循环类似的。

 */
var square = 0
var diceRoll = 0
repeat {
    square += array[square]
    // roll the dice
    diceRoll = Int((arc4random() % 6) + 1);
    // move by the rolled amount
    square += diceRoll
}while square < count
print("Game over!")


