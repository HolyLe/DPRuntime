import UIKit

var str = "Hello, playground"
/*
--------------------------------------------------------- 类和结构体
 在 Swift 中类和结构体有很多共同之处，它们都能：
 
 定义属性用来存储值；
 定义方法用于提供功能；
 定义下标脚本用来允许使用下标语法访问值；
 定义初始化器用于初始化状态；
 可以被扩展来默认所没有的功能；
 遵循协议来针对特定类型提供标准功能。
 
 类有而结构体没有的额外功能：
 
 继承允许一个类继承另一个类的特征;
 类型转换允许你在运行检查和解释一个类实例的类型；
 反初始化器允许一个类实例释放任何其所被分配的资源；
 引用计数允许不止一个对类实例的引用。
 
 结构体在你的代码中通过复制来传递，并且并不会使用引用计数。
 */

//定义语法
/*
 无论你在何时定义了一个新的类或者结构体，实际上你定义了一个全新的 Swift 类型。请用 UpperCamelCase 命名法[1]命名 (比如这里我们说到的 SomeClass和 SomeStructure)以符合 Swift 的字母大写风格（比如说 String ， Int 以及 Bool）。相反，对于属性和方法使用 lowerCamelCase命名法[1] (比如 frameRate 和 incrementCount)，以此来区别于类型名称。
 */
class SomeClass {
    // class definition goes here
}
struct SomeStructure {
    // structure definition goes here
}


struct Resolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

//类与结构体实例
let someResolution = Resolution()
let someVideoMode = VideoMode()


//访问属性,你可以用点语法来访问一个实例的属性。
someVideoMode.resolution.width = 1280
//结构体类型的成员初始化器

//所有的结构体都有一个自动生成的成员初始化器，你可以使用它来初始化新结构体实例的成员属性。新实例属性的初始化值可以通过属性名称传递到成员初始化器中：
let vga = Resolution(width: 640, height: 480)//与结构体不同，类实例不会接收默认的成员初始化器，

//结构体和枚举是值类型
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
cinema.width = 2048
print("cinema is now \(cinema.width) pixels wide")
print("hd is still \(hd.width) pixels wide")
//当 cinema被赋予 hd的当前值，存储在 hd中的值就被拷贝给了新的 cinema实例。这最终的结果是两个完全不同的实例，它们只是碰巧包含了相同的数字值。由于它们是完全不同的实例， cinema的宽度被设置 2048并不影响 hd中 width存储的值。

enum CompassPoint {
    case North, South, East, West
}
var currentDirection = CompassPoint.West
let rememberedDirection = currentDirection
currentDirection = .East
if rememberedDirection == .West {
    print("The remembered direction is still .West")
}
//当 rememberedDirection被赋予了 currentDirection中的值，实际上是值的拷贝。之后再改变 currentDirection的值并不影响 rememberedDirection所存储的原版值。
//类是引用类型
let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")
//注意 tenEighty和 alsoTenEighty都被声明为常量。然而，你仍然能改变 tenEighty.frameRate和 alsoTenEighty.frameRate因为 tenEighty和 alsoTenEighty常量本身的值不会改变。 tenEighty和 alsoTenEighty本身是并没有存储 VideoMode实例—相反，它们两者都在后台指向了 VideoMode实例。这是 VideoMode的 frameRate参数在改变而不是引用 VideoMode的常量的值在改变。
/*------特征运算符
 因为类是引用类型，在后台有可能有很多常量和变量都是引用到了同一个类的实例。(相同这词对结构体和枚举来说并不是真的相同，因为它们在赋予给常量，变量或者被传递给一个函数时总是被拷贝过去的。)
 
 有时候找出两个常量或者变量是否引用自同一个类实例非常有用，为了允许这样，Swift提供了两个特点运算符
相同于 ( ===)
不相同于( !==)
*/
if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}
/*
 指针
 如果你有过 C，C++ 或者 Objective-C 的经验，你可能知道这些语言使用可指针来引用内存中的地址。一个 Swift 的常量或者变量指向某个实例的引用类型和 C 中的指针类似，但是这并不是直接指向内存地址的指针，也不需要你书写星号( *)来明确你建立了一个引用。相反，这些引用被定义得就像 Swift 中其他常量或者变量一样。
 */

/*类和结构体之间的选择
类和结构体都可以用来定义自定义的数据类型，作为你的程序代码构建块。

总之，结构体实例总是通过值来传递，而类实例总是通过引用来传递。这意味着他们分别适用于不同类型的任务。当你考虑你的工程项目中数据结构和功能的时候，你需要决定把每个数据结构定义成类还是结构体。

按照通用准则，当符合以下一条或多条情形时应考虑创建一个结构体：

结构体的主要目的是为了封装一些相关的简单数据值；
当你在赋予或者传递结构实例时，有理由需要封装的数据值被拷贝而不是引用；
任何存储在结构体中的属性是值类型，也将被拷贝而不是被引用；
结构体不需要从一个已存在类型继承属性或者行为。
合适的结构体候选者包括：

几何形状的大小，可能封装了一个 width属性和 height属性，两者都为 double类型；
一定范围的路径，可能封装了一个 start属性和 length属性，两者为 Int类型；
三维坐标系的一个点，可能封装了 x , y 和 z属性，他们都是 double类型。
在其他的情况下，定义一个类，并创建这个类的实例通过引用来管理和传递。事实上，大部分的自定义的数据结构应该是类，而不是结构体。

字符串，数组和字典的赋值与拷贝行为
Swift 的 String , Array 和 Dictionary类型是作为结构体来实现的，这意味着字符串，数组和字典在它们被赋值到一个新的常量或者变量，亦或者它们本身被传递到一个函数或方法中的时候，其实是传递了拷贝。

这种行为不同于基础库中的 NSString, NSArray和 NSDictionary，它们是作为类来实现的，而不是结构体。 NSString , NSArray 和 NSDictionary实例总是作为一个已存在实例的引用而不是拷贝来赋值和传递。

注意

在上述有关字符串，数组和字典“拷贝”的描述中。你在代码中所见到的行为好像总是拷贝。然而在后台 Swift 只有在需要这么做时才会实际去拷贝。Swift 能够管理所有的值的拷贝来确保最佳的性能，所有你也没必要为了保证最佳性能来避免赋值。

译注
[1] CamelCase names ：在给储存器或者函数命名时我们习惯上把多个有意义的单词以开头大写的形式拼接在一起组成一个单一的长单词。这种方法被称为“驼峰式命名法”，又分为开头大写和开头小写两种。比如说 SomeClass 、 frameRate 等。
*/


/*
 ---------------------------------------------属性
 
 属性可以将值与特定的类、结构体或者是枚举联系起来。存储属性会存储常量或变量作为实例的一部分，反之计算属性会计算（而不是存储）值。计算属性可以由类、结构体和枚举定义。存储属性只能由类和结构体定义。
 
 存储属性和计算属性通常和特定类型的实例相关联。总之，属性也可以与类型本身相关联。这种属性就是所谓的类型属性。
 
 另外，你也可以定义属性观察器来检查属性中值的变化，这样你就可以用自定义的行为来响应。属性观察器可以被添加到你自己定义的存储属性中，也可以添加到子类从他的父类那里所继承来的属性中。
 */
//存储属性

struct FixedLengthRange {
    let firstValue: Int
    var length: Int
}
let rangeOfThreeItems = FixedLengthRange(firstValue: 1, length: 2)

//rangeOfThreeItems.length = 1 //error
//这是由于结构体是值类型。当一个值类型的实例被标记为常量时，该实例的其他属性也均为常量。
//常量结构体实例的存储属性
//对于类来说则不同，它是引用类型。如果你给一个常量赋值引用类型实例，你仍然可以修改那个实例的变量属性。

/*
 延迟存储属性
 延迟存储属性的初始值在其第一次使用时才进行计算。你可以通过在其声明前标注 lazy 修饰语来表示一个延迟存储属性。
 你必须把延迟存储属性声明为变量（使用 var 关键字），因为它的初始值可能在实例初始化完成之前无法取得。常量属性则必须在初始化完成之前有值，因此不能声明为延迟。
 一个属性的初始值可能依赖于某些外部因素，当这些外部因素的值只有在实例的初始化完成后才能得到时，延迟属性就可以发挥作用了。而当属性的初始值需要执行复杂或代价高昂的配置才能获得，你又想要在需要时才执行，延迟属性就能够派上用场了。
 */
class DataImporter {
    
    //DataImporter is a class to import data from an external file.
    //The class is assumed to take a non-trivial amount of time to initialize.
    
    var fileName = "data.txt"
    // the DataImporter class would provide data importing functionality here
}

class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
    // the DataManager class would provide data management functionality here
}

let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")


//注意

//如果被标记为 lazy 修饰符的属性同时被多个线程访问并且属性还没有被初始化，则无法保证属性只初始化一次。

/*
 存储属性与实例变量
 如果你有 Objective-C 的开发经验，那你应该知道在类实例里有两种方法来存储值和引用。另外，你还可以使用实例变量作为属性中所储存的值的备份存储。
 
 Swift 把这些概念都统一到了属性声明里。Swift 属性没有与之相对应的实例变量，并且属性的后备存储不能被直接访问。这避免了不同环境中对值的访问的混淆并且将属性的声明简化为一条单一的、限定的语句。所有关于属性的信息——包括它的名字，类型和内存管理特征——都作为类的定义放在了同一个地方。
 */

/*
 计算属性
 除了存储属性，类、结构体和枚举也能够定义计算属性，而它实际并不存储值。相反，他们提供一个读取器和一个可选的设置器来间接得到和设置其他的属性和值。
 */
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}

var square = Rect(origin: Point(x: 0.0, y: 0.0),
                  size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")

/*
 只读计算属性
 一个有读取器但是没有设置器的计算属性就是所谓的只读计算属性。只读计算属性返回一个值，也可以通过点语法访问，但是不能被修改为另一个值。
 你必须用 var 关键字定义计算属性——包括只读计算属性——为变量属性，因为它们的值不是固定的。 let 关键字只用于常量属性，用于明确那些值一旦作为实例初始化就不能更改。
 你可以通过去掉 get 关键字和他的大扩号来简化只读计算属性的声明：
 
 */
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")

/*
 属性观察者
 属性观察者会观察并对属性值的变化做出回应。每当一个属性的值被设置时，属性观察者都会被调用，即使这个值与该属性当前的值相同。
 
 你可以为你定义的任意存储属性添加属性观察者，除了延迟存储属性。你也可以通过在子类里重写属性来为任何继承属性（无论是存储属性还是计算属性）添加属性观察者。属性重载将会在重写中详细描述。
 你不需要为非重写的计算属性定义属性观察者，因为你可以在计算属性的设置器里直接观察和相应它们值的改变。
 willSet 会在该值被存储之前被调用。
 didSet 会在一个新值被存储后被调用。
 
 果你实现了一个 willSet 观察者，新的属性值会以常量形式参数传递。你可以在你的 willSet 实现中为这个参数定义名字。如果你没有为它命名，那么它会使用默认的名字 newValue 。
 
 同样，如果你实现了一个 didSet观察者，一个包含旧属性值的常量形式参数将会被传递。你可以为它命名，也可以使用默认的形式参数名 oldValue 。如果你在属性自己的 didSet 观察者里给自己赋值，你赋值的新值就会取代刚刚设置的值。
 */
class StepCounter {
    
    var totalSteps: Int = 0 {
        willSet{
            
            print("About to set totalSteps to \(newValue)")
            
        }
        didSet {
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
let aab = StepCounter()

aab.totalSteps = 5

/*
 
 类属性
 */
struct SomeStructure21 {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClass21 {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

print(SomeClass21.overrideableComputedTypeProperty)

//----------------------------------------------------------------方法

/*
 实例方法
 
 
 */
class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount : Int) {
        count += amount
    }
    
    func reset() {
        count = 0
    }
}
/*
 self属性：每一个类的实例都隐含一个叫做 self的属性，它完完全全与实例本身相等。你可以使用 self属性来在当前实例当中调用它自身的方法。
 实际上，你不需要经常在代码中写 self。如果你没有显式地写出 self，Swift会在你于方法中使用已知属性或者方法的时候假定你是调用了当前实例中的属性或者方法。这个假定通过在 Counter的三个实例中使用 count（而不是 self.count）来做了示范。
 对于这个规则的一个重要例外就是当一个实例方法的形式参数名与实例中某个属性拥有相同的名字的时候。在这种情况下，形式参数名具有优先权，并且调用属性的时候使用更加严谨的方式就很有必要了。你可以使用 self属性来区分形式参数名和属性名。
 */
struct Point1 {
    var x = 0.0, y = 0.0
    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x
    }
    /*
     在实例方法中修改值类型
     
     结构体和枚举是值类型。默认情况下，值类型属性不能被自身的实例方法修改。
     总之，如果你需要在特定的方法中修改结构体或者枚举的属性，你可以选择将这个方法异变。然后这个方法就可以在方法中异变（嗯，改变）它的属性了，并且任何改变在方法结束的时候都会写入到原始的结构体中。方法同样可以指定一个全新的实例给它隐含的 self属性，并且这个新的实例将会在方法结束的时候替换掉现存的这个实例。
     你可以选择在 func关键字前放一个 mutating关键字来使用这个行为：
     */
    mutating func moveBy(x deltaX : Double, y deltaY : Double){
        x += deltaX
        y += deltaY
    }
    
    /*
     异变方法可以指定整个实例给隐含的 self属性。上文中那个 Point的栗子可以用下边的代码代替：

     */
    mutating func moveBy(_ deltaX : Double, _ deltaY : Double){
        self = Point1(x: x + deltaX, y: y + deltaY)
    }
}
let somePoint1 = Point1(x: 4.0, y: 5.0)

if somePoint1.isToTheRightOf(x: 1.0) {
    print("This point is to the right of the line where x == 1.0")
}
var somePoint2 = Point1(x: 1.0, y: 1.0)
somePoint2.moveBy(x: 2.0, y: 3.0)
print("The point is now at (\(somePoint2.x), \(somePoint2.y))")
enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}
var ovenLight = TriStateSwitch.low
ovenLight.next()

ovenLight.next()

/*
 类型方法
 实例方法是特定类型实例中调用的方法。你同样可以定义在类型本身调用的方法。这类方法被称作类型方法。你可以通过在 func关键字之前使用 static关键字来明确一个类型方法。类同样可以使用 class关键字来允许子类重写父类对类型方法的实现
 */
class MyClass {
    static func somTypeMethod() {
        print("这是类方法")
    }
}

MyClass.somTypeMethod()

/*
 在类型方法的函数体中，隐含的 self属性指向了类本身而不是这个类的实例。对于结构体和枚举，这意味着你可以使用 self来消除类型属性和类型方法形式参数之间的歧义，用法和实例属性与实例方法形式参数之间的用法完全相同
 */
struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1
    
    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel { highestUnlockedLevel = level }
    }
    
    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    
    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}
class Player {
    var tracker = LevelTracker()
    
    
    let playerName: String
    func complete(level: Int) {
        LevelTracker.unlock(level + 1)
        tracker.advance(to: level + 1)
    }
    init(_ name: String) {
        playerName = name
    }
    private(set) var name: String?
}

var player = Player.init("Argyrios")


player.complete(level: 7)

player = Player.init("Beto")

if player.tracker.advance(to: 6) {
    print("player is now on level 6")
} else {
    print("level 6 has not yet been unlocked")
}


let f = Point1.isToTheRightOf
let point3 = Point1.init(x: 1, y: 1)

let f2 = f(point3)(1)
print(f2)

let f3 = LevelTracker.advance

var point4 = LevelTracker()

let f4 = f3(&point4)(8)
print(f4)


struct maxiaoliang{
    var aav = 1
    
    mutating func aa(_ num : Int, _ num1 : Int) -> Int{
        aav = num1 + num
        return 1 + num + num1
    }
}

let bba = maxiaoliang.aa

var bbb = maxiaoliang()

let bbc = bba(&bbb)(3,-3)


/*
 下标
 
 类、结构体和枚举可以定义下标，它可以作为访问集合、列表或序列成员元素的快捷方式。你可使用下标通过索引值来设置或检索值而不需要为设置和检索分别使用实例方法。比如说，用 someArray[index] 来访问 Array 实例中的元素以及用 someDictionary[key] 访问 Dictionary 实例中的元素。
 
 你可以为一个类型定义多个下标，并且下标会基于传入的索引值的类型选择合适的下标重载使用。下标没有限制单个维度，你可以使用多个输入形参来定义下标以满足自定义类型的需求。
 */

//定义下标

struct TimesTable {
    let multiplier :Int
    subscript(index : Int) -> Int{
        return multiplier * index
    }
    subscript(index : Int, inx : Int) -> Int{
        return multiplier * index * inx
    }
}
let threTimesRable = TimesTable(multiplier: 3)
print("six times three is \(threTimesRable[6,10])")

/*
 下标选项
 
 下标可以接收任意数量的输入形式参数，并且这些输入形式参数可以是任意类型。下标也可以返回任意类型。下标可以使用变量形式参数和可变形式参数，但是不能使用输入输出形式参数或提供默认形式参数值。
 

 */
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
var matrix = Matrix(rows: 2, columns: 2)
matrix[0, 1] = 1.5
matrix[1, 0] = 3.2

print(matrix)



