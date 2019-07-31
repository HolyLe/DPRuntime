import UIKit

var str = "Hello, playground"

//---------------------------------------------------函数
//定义
func greet(person : String) -> String{
    let greeting = "Hello," + person + "!"
    return greeting
}

 print(greet(person: "maxiaoliang"))

func greetAgain(person: String) -> String {
    return "Hello again, " + person + "!"
}
print(greetAgain(person: "Anna"))

/*函数形式参数和返回值*/
//无参数
func sayHellloWorld() -> String{
    return "hello, world"
}
//多形式参数的函数

func greet(person: String, alreadyGreeted: Bool) -> String {
    if alreadyGreeted {
        return greetAgain(person: person)
    } else {
        return greet(person: person)
    }
}
print(greet(person: "Tim", alreadyGreeted: true))

//无返回值
func greet1(person: String) {
    print("Hello, \(person)!")
}
greet1(person: "Dave")


//多返回值的函数
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}

minMax(array: [1,2,3,4,5]).0
minMax(array: [1,2,3,4,5]).min

//可选元组返回类型:如果元组在函数的返回类型中有可能“没有值”，你可以用一个可选元组返回类型来说明整个元组的可能是 nil 。书法是在可选元组类型的圆括号后边添加一个问号（ ?）例如 (Int, Int)?  或者 (String, Int, Bool)?

//注意

//类似 (Int, Int)?的可选元组类型和包含可选类型的元组 (Int?, Int?)是不同的。对于可选元组类型，整个元组是可选的，而不仅仅是元组里边的单个值。

func minMax1(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
if let bounds = minMax1(array: [8, -6, 2, 109, 3, 71]) {
    print("min is \(bounds.min) and max is \(bounds.max)")
}
//指定实际参数标签

func greet2(people person: String, from hometown: String) -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
print(greet2(people: "hehe", from: "adfa"))


//默认参数
func someFunction(parameterWithDefault: Int = 12) {
    // In the function body, if no arguments are passed to the function
    // call, the value of parameterWithDefault is 12.
}
someFunction(parameterWithDefault: 6) // parameterWithDefault is 6
someFunction() // parameterWithDefault is 12

//可变形式参数

/*
 一个可变形式参数可以接受零或者多个特定类型的值。当调用函数的时候你可以利用可变形式参数来声明形式参数可以被传入值的数量是可变的。可以通过在形式参数的类型名称后边插入三个点符号（ ...）来书写可变形式参数。
 传入到可变参数中的值在函数的主体中被当作是对应类型的数组。举个栗子，一个可变参数的名字是 numbers类型是 Double...在函数的主体中它会被当作名字是 numbers 类型是 [Double]的常量数组。
 */

func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
// returns 3.0, which is the arithmetic mean of these five numbers
arithmeticMean(3, 8.25, 18.75)

//输入输出形式参数

/*
 可变形式参数只能在函数的内部做改变。如果你想函数能够修改一个形式参数的值，而且你想这些改变在函数结束之后依然生效，那么就需要将形式参数定义为输入输出形式参数。
 在形式参数定义开始的时候在前边添加一个 inout关键字可以定义一个输入输出形式参数。输入输出形式参数有一个能输入给函数的值，函数能对其进行修改，还能输出到函数外边替换原来的值。
 你只能把变量作为输入输出形式参数的实际参数。你不能用常量或者字面量作为实际参数，因为常量和字面量不能修改。在将变量作为实际参数传递给输入输出形式参数的时候，直接在它前边添加一个和符号 ( &) 来明确可以被函数修改。
 输入输出形式参数不能有默认值，可变形式参数不能标记为 inout，如果你给一个形式参数标记了 inout，那么它们也不能标记 var和 let了。
 */
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
//输入输出形式参数与函数的返回值不同。上边的 swapTwoInts没有定义返回类型和返回值，但它仍然能修改 someInt和 anotherInt的值。输入输出形式参数是函数能影响到函数范围外的另一种替代方式。

//函数类型：每一个函数都有一个特定的函数类型，它由形式参数类型，返回类型组成。
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}
/*
 这两个函数的类型都是 (Int, Int) -> Int 。也读作：
 “有两个形式参数的函数类型，它们都是 Int类型，并且返回一个 Int类型的值。”
 
 下边的另外一个栗子，一个没有形式参数和返回值的函数。
 这个函数的类型是 () -> Void，或者 “一个没有形式参数的函数，返回 Void。
*/
func printHelloWorld() {
    print("hello, world")
}
//使用函数类型

/*
 你可以像使用 Swift 中的其他类型一样使用函数类型。例如，你可以给一个常量或变量定义一个函数类型，并且为变量指定一个相应的函数。
 */

var mathFunction: (Int, Int) -> Int = addTwoInts

print("Result: \(mathFunction(2, 3))")

let anotherMathFunction = addTwoInts

//函数类型作为形式参数类型

func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)
/*
 函数 printMathResult(_:_:_:)的作用就是当调用一个相应类型的数学函数的时候打印出结果。它并不关心函数在实现过程中究竟做了些什么，它只关心函数是不是正确的类型。这使得函数 printMathResult(_:_:_:)以一种类型安全的方式把自身的功能传递给调用者。
 */

//函数类型作为返回值
/*
 
 下边的栗子定义了两个简单函数叫做 stepForward(_:)和 stepBackward(_:)。函数 stepForward(_:)返回一个大于输入值的值，而 stepBackward(_:)返回一个小于输入值的值。这两个函数的类型都是 (Int) -> Int：
 
 */
func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}

func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
    return backwards ? stepBackward : stepForward
}

var currentValue = 3

let moveNearerToZero = chooseStepFunction(backwards: currentValue > 0)

print("Counting to zero:")
// Counting to zero:
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")

//内嵌函数
/*
 
 */
func chooseStepFunction1(backward: Bool) -> (Int) -> Int {
    func stepForward1(input: Int) -> Int { return input + 1 }
    func stepBackward1(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward1 : stepForward1
}
var currentValue1 = -4
let moveNearerToZero1 = chooseStepFunction1(backward: currentValue > 0)
// moveNearerToZero now refers to the nested stepForward() function
while currentValue1 != 0 {
    print("\(currentValue1)... ")
    currentValue1 = moveNearerToZero1(currentValue1)
}
print("zero!")
// -4...
// -3...
// -2...
// -1...
// zero!

//--------------------------------------------闭包
//排序
func backward(_ s1 : String,_ s2 : String) -> Bool{
    return s1 > s2
}
let names = ["Chris","Alex","Ewa","Barry","Daniella"]
var reversedNames = names.sorted(by: backward)
print(reversedNames)
//闭包写法
reversedNames = names.sorted(by: {(s1 : String, s2 : String) -> Bool in
    return s1 < s2
})
print(reversedNames)
/*
 从语句中推断类型
 因排序闭包为实际参数来传递给函数，故 Swift 能推断它的形式参数类型和返回类型。
 sorted(by:) 方法期望它的第二个形式参数是一个 (String, String) -> Bool 类型的函数。
 这意味着 (String, String)和 Bool 类型不需要被写成闭包表达式定义中的一部分，因为所有的类型都能被推断，
 返回箭头 ( ->) 和围绕在形式参数名周围的括号也能被省略：
*/
reversedNames = names.sorted(by: {s1, s2 in return s1 > s2})

print(reversedNames)

reversedNames = names.sorted(by: { s1, s2 in s1 > s2 })
print(reversedNames)
/*从单表达式闭包隐式返回,
单表达式闭包能够通过从它们的声明中删掉 return 关键字来隐式返回它们单个表达式的结果，前面的栗子可以写作,这里， sorted(by:) 方法的第二个实际参数的函数类型已经明确必须通过闭包返回一个 Bool 值。因为闭包的结构包涵返回 Bool 值的单一表达式 (s1 > s2)，因此没有歧义，并且 return 关键字能够被省略。
*/
/*
 简写的实际参数名
 Swift 自动对行内闭包提供简写实际参数名，你也可以通过 $0 , $1 , $2 等名字来引用闭包的实际参数值。
 
 如果你在闭包表达式中使用这些简写实际参数名，那么你可以在闭包的实际参数列表中忽略对其的定义，并且简写实际参数名的数字和类型将会从期望的函数类型中推断出来。 in  关键字也能被省略，因为闭包表达式完全由它的函数体组成
 */
reversedNames = names.sorted(by: {$0 > $1})
print(reversedNames)
/*
 运算符函数
 
 实际上还有一种更简短的方式来撰写上述闭包表达式。Swift 的 String 类型定义了关于大于号（ >）的特定字符串实现，让其作为一个有两个 String 类型形式参数的函数并返回一个 Bool 类型的值。这正好与  sorted(by:) 方法的第二个形式参数需要的函数相匹配。因此，你能简单地传递一个大于号，并且 Swift 将推断你想使用大于号特殊字符串函数实现：
 */
reversedNames = names.sorted(by: >)
print(reversedNames)




/*
 尾随闭包
 
 
 如果你需要将一个很长的闭包表达式作为函数最后一个实际参数传递给函数，使用尾随闭包将增强函数的可读性。尾随闭包是一个被书写在函数形式参数的括号外面（后面）的闭包表达式：
 
 */
func somFim (closure:() ->Void){
    
}

let digitNames = [
    0: "Zero",1: "One",2: "Two",  3: "Three",4: "Four",
    5: "Five",6: "Six",7: "Seven",8: "Eight",9: "Nine"
]

let numbers = [16,58,510]

let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    }while number > 0
    return output
}
/*
 捕获值
 一个闭包能够从上下文捕获已被定义的常量和变量。即使定义这些常量和变量的原作用域已经不存在，闭包仍能够在其函数体内引用和修改这些值。
 在 Swift 中，一个能够捕获值的闭包最简单的模型是内嵌函数，即被书写在另一个函数的内部。一个内嵌函数能够捕获外部函数的实际参数并且能够捕获任何在外部函数的内部定义了的常量与变量。
 incrementer() 函数是没有任何形式参数， runningTotal 和 amount 不是来自于函数体的内部，而是通过捕获主函数的 runningTotal 和 amount 把它们内嵌在自身函数内部供使用。当调用 makeIncrementer  结束时通过引用捕获来确保不会消失，并确保了在下次再次调用 incrementer 时， runningTotal 将继续增加。
 */
var aa1 = 1

func makeIncrementer(forIncrement amount: Int) ->  () -> Int{
//    var runningTotal = 0
    func incrementer() -> Int {
        aa1 += amount
        return aa1
    }
    return incrementer
}
let aab = makeIncrementer(forIncrement: 1)
var a = aab()
print(a)
print(aa1)
a = aab()
print(a)
print(aa1)
a = aab()
print(a)
print(aa1)

/*
 闭包是引用类型
 在上面例子中， incrementBySeven 和 incrementByTen 是常量，但是这些常量指向的闭包仍可以增加已捕获的变量 runningTotal 的值。这是因为函数和闭包都是引用类型。
 无论你什么时候赋值一个函数或者闭包给常量或者变量，你实际上都是将常量和变量设置为对函数和闭包的引用。这上面这个例子中，闭包选择 incrementByTen 指向一个常量，而不是闭包它自身的内容。
 这也意味着你赋值一个闭包到两个不同的常量或变量中，这两个常量或变量都将指向相同的闭包：
 */
let alsoIncrementByTen = aab
aab()
//return a value of 5

/*
 逃逸闭包
 当闭包作为一个实际参数传递给一个函数的时候，我们就说这个闭包逃逸了，因为它可以在函数返回之后被调用。当你声明一个接受闭包作为形式参数的函数时，你可以在形式参数前写 @escaping 来明确闭包是允许逃逸的。
 
 闭包可以逃逸的一种方法是被储存在定义于函数外的变量里。比如说，很多函数接收闭包实际参数来作为启动异步任务的回调。函数在启动任务后返回，但是闭包要直到任务完成——闭包需要逃逸，以便于稍后调用。举例来说：
 
 让闭包 @escaping 意味着你必须在闭包中显式地引用 self ，比如说，下面的代码中，传给 someFunctionWithEscapingClosure(_:) 的闭包是一个逃逸闭包，也就是说它需要显式地引用 self 。相反，传给 someFunctionWithNonescapingClosure(_:) 的闭包是非逃逸闭包，也就是说它可以隐式地引用 self 。
 */
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}
class SomeClass{
    var x = 10
    
    func doingSomething() {
        someFunctionWithEscapingClosure {
            self.x = 100
        }
        someFunctionWithNonescapingClosure {
            x = 200
        }
    }
    
}

let instance = SomeClass()

instance.doingSomething()

print(instance.x)

completionHandlers.first?()

print(instance.x)


/*
 自动闭包是一种自动创建的用来把作为实际参数传递给函数的表达式打包的闭包。它不接受任何实际参数，并且当它被调用时，它会返回内部打包的表达式的值。这个语法的好处在于通过写普通表达式代替显式闭包而使你省略包围函数形式参数的括号。
 
*/
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)
// Prints "5"

let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)
// Prints "5"

print("Now serving \(customerProvider())!")
// Prints "Now serving Chris!"
print(customersInLine.count)
// Prints "4"

func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )
/*
 注意
 
 滥用自动闭包会导致你的代码难以读懂。上下文和函数名应该写清楚求值是延迟的。
 执行相同的任务但是不使用明确的闭包而是通过 @autoclosure 标志标记它的形式参数使用了自动闭包。实际参数自动地转换为闭包，因为 customerProvider 形式参数的类型被标记为 @autoclosure 标记。
 
 如果你想要自动闭包允许逃逸，就同时使用 @autoclosure 和 @escaping 标志。 @escaping 标志在上边的逃逸闭包里有详细的解释。
 */
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))

var customerProviders1: [() -> String] = []
func collectCustomerProviders1(_ customerProvider1: @autoclosure @escaping () -> String) {
    customerProviders1.append(customerProvider1)
}
collectCustomerProviders1(customersInLine.remove(at: 0))
collectCustomerProviders1(customersInLine.remove(at: 0))

print("Collected \(customerProviders1.count) closures.")
// Prints "Collected 2 closures."
for customerProvider in customerProviders1 {
    print("Now serving \(customerProvider())!")
}
