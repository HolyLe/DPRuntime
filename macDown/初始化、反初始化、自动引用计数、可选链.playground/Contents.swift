import UIKit

//-----------------------------------------初始化
/*
 初始化器
 
 当你给一个存储属性分配默认值，或者在一个初始化器里设置它的初始值的时候，属性的值就会被直接设置，不会调用任何属性监听器。
 */

struct ma {
    var temperature: Double
    init() {
        temperature = 32.0
    }
}
/*
 默认的属性值
 如果一个属性一直保持相同的初始值，可以提供一个默认值而不是在初始化器里设置这个值。最终结果是一样的，但是默认值将属性的初始化与声明更紧密地联系到一起。它使得你的初始化器更短更清晰，并且可以让你属性根据默认值推断类型。如后边的章节所述，默认值也让你使用默认初始化器和初始化器继承更加容易。
 */
struct ma1 {
    var temperature = 32.0
}
//自定义初始化

/*
 初始化形式参数
 */
struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
// boilingPointOfWater.temperatureInCelsius is 100.0
let freezingPointOfWater = Celsius(fromKelvin: 273.15)

/*
 形式参数名和实际参数标签
 */

struct Color {
    let red, green, blue : Double
    init(red : Double, green : Double, blue :Double) {
        self.red = red;
        self.green = green
        self.blue = blue
    }
    init(white : Double) {
        self.red = white;
        self.green = white
        self.blue = white
    }
}


let color = Color(white: 0.5)
print(color.red)

/*
 无实际参数标签的初始化器形式参数
 */

struct Celsius1 {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius: Double) {
        temperatureInCelsius = celsius
    }
}
let bodyTemperature = Celsius1(37.0)


/*
 可选属性类型
 如果你的自定义类型有一个逻辑上是允许“无值”的存储属性——大概因为它的值在初始化期间不能被设置，或者因为它在稍后允许设置为“无值”——声明属性为可选类型。可选类型的属性自动地初始化为 nil ，表示该属性在初始化期间故意设为“还没有值”。
 */


class SurveyQuestion {
    var text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.ask()
// prints "Do you like cheese?"
cheeseQuestion.response = "Yes, I do like cheese."


/*
 在初始化中分配常量属性
 在初始化的任意时刻，你都可以给常量属性赋值，只要它在初始化结束是设置了确定的值即可。一旦为常量属性被赋值，它就不能再被修改了。
 */


class SurveyQuestion1 {
    let text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let cheeseQuestion1 = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion1.ask()
// prints "Do you like cheese?"
cheeseQuestion1.response = "Yes, I do like cheese."

/*
 
 默认初始化器
 
 Swift 为所有没有提供初始化器的结构体或类提供了一个默认的初始化器来给所有的属性提供了默认值。这个默认的初始化器只是简单地创建了一个所有属性都有默认值的新实例。
 */
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}
var item = ShoppingListItem()

/*
 结构体类型的成员初始化器
 
 如果结构体类型中没有定义任何自定义初始化器，它会自动获得一个成员初始化器。不同于默认初始化器，结构体会接收成员初始化器即使它的存储属性没有默认值。
 */

struct Size {
    var width = 0.0, height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)

/*
 值类型的初始化器委托
 初始化器可以调用其他初始化器来执行部分实例的初始化。这个过程，就是所谓的初始化器委托，避免了多个初始化器里冗余代码。
 
 初始化器委托的运作，以及允许那些形式的委托，这些规则对于值类型和类类型是不同的。值类型(结构体和枚举)不支持继承，所以他它们的初始化器委托的过程相当简单，因为它们只能提供它们自己为另一个初始化器委托。如同继承里描述的那样，总之，类可以从其他类继承。这就意味着类有额外的责任来确保它们继承的所有存储属性在初始化期间都分配了一个合适的值。这些责任在下边的类的继承和初始化里做详述。
 
 对于值类型，当你写自己自定义的初始化器时可以使用 self.init 从相同的值类型里引用其他初始化器。你只能从初始化器里调用 self.init 。
 注意如果你为值类型定义了自定义初始化器，你就不能访问那个类型的默认初始化器(或者是成员初始化器，如果是结构体的话)。这个限制防止了别人意外地使用自动初始化器从而绕过复杂初始化器里提供的额外必要配置这种情况的发生。
 如果你想要你自己的自定义值类型能够使用默认初始化器和成员初始化器初始化，以及你的自定义初始化器来初始化，把你的自定义初始化器写在扩展里而不是作为值类型原始实的一部分。想要了解更多的信息，请看扩展。
 
 类的继承和初始化
 
 所有类的存储属性——包括从它的父类继承的所有属性——都必须在初始化期间分配初始值。
 
 Swift 为类类型定义了两种初始化器以确保所有的存储属性接收一个初始值。这些就是所谓的指定初始化器和便捷初始化器。
 
 指定初始化器和便捷初始化器
 指定初始化器是类的主要初始化器。指定的初始化器可以初始化所有那个类引用的属性并且调用合适的父类初始化器来继续这个初始化过程给父类链。
 类偏向于少量指定初始化器，并且一个类通常只有一个指定初始化器。指定初始化器是初始化开始并持续初始化过程到父类链的“传送”点。
 每个类至少得有一个指定初始化器。如同在初始化器的自动继承里描述的那样，在某些情况下，这些需求通过从父类继承一个或多个指定初始化器来满足。
 便捷初始化器是次要的，为一个类支持初始化器。你可以在相同的类里定义一个便捷初始化器来调用一个指定的初始化器作为便捷初始化器来给指定初始化器设置默认形式参数。你也可以为具体的使用情况或输入的值类型定义一个便捷初始化器从而创建这个类的实例
 如果你的类不需要便捷初始化器你可以不提供它。在为通用的初始化模式创建快捷方式以节省时间或者类的初始化更加清晰明了的时候便捷初始化器。
 
 指定初始化器和便捷初始化器语法
 
 便捷初始化器有着相同的书写方式，但是要用 convenience 修饰符放到 init 关键字前，用空
 
 
 
 类类型的初始化器委托
 为了简化指定和便捷初始化器之间的调用关系，Swift 在初始化器之间的委托调用有下面的三个规则:
 规则 1
 指定初始化器必须从它的直系父类调用指定初始化器。
 
 规则 2
 便捷初始化器必须从相同的类里调用另一个初始化器。
 
 规则 3
 便捷初始化器最终必须调用一个指定初始化器。
 
 简单记忆的这些规则的方法如下：
 
 指定初始化器必须总是向上委托。
 便捷初始化器必须总是横向委托。
 
 这些规则不会影响你的类的使用者为每个类创建实例。任何上图的初始化器都可以用来完整创建对应类的实例。这个规则只在类的实现时有影响。
 
 两段式初始化
 
 Swift 的类初始化是一个两段式过程。在第一个阶段，每一个存储属性被引入类为分配了一个初始值。一旦每个存储属性的初始状态被确定，第二个阶段就开始了，每个类都有机会在新的实例准备使用之前来定制它的存储属性。
 
 两段式初始化过程的使用让初始化更加安全，同时在每个类的层级结构给与了完备的灵活性。两段式初始化过程可以防止属性值在初始化之前被访问，还可以防止属性值被另一个初始化器意外地赋予不同的值。
 Swift 的两段式初始化过程与 Objective-C 的初始化类似。主要的不同点是在第一阶段，Objective-C 为每一个属性分配零或空值(例如 0 或 nil )。Swift 的初始化流程更加灵活，它允许你设置自定义的初始值，并可以自如应对那些不把 0 或 nil 做为合法值的类型。
 
 
 Swift编译器执行四种有效的安全检查来确保两段式初始化过程能够顺利完成：
 
 安全检查 1
 指定初始化器必须保证在向上委托给父类初始化器之前，其所在类引入的所有属性都要初始化完成。
 
 如上所述，一个对象的内存只有在其所有储存型属性确定之后才能完全初始化。为了满足这一规则，指定初始化器必须保证它自己的属性在它上交委托之前先完成初始化。
 
 安全检查 2
 指定初始化器必须先向上委托父类初始化器，然后才能为继承的属性设置新值。如果不这样做，指定初始化器赋予的新值将被父类中的初始化器所覆盖。
 
 安全检查 3
 便捷初始化器必须先委托同类中的其它初始化器，然后再为任意属性赋新值（包括同类里定义的属性）。如果没这么做，便捷构初始化器赋予的新值将被自己类中其它指定初始化器所覆盖。
 
 安全检查 4
 初始化器在第一阶段初始化完成之前，不能调用任何实例方法、不能读取任何实例属性的值，也不能引用 self 作为值。
 
 直到第一阶段结束类实例才完全合法。属性只能被读取，方法也只能被调用，直到第一阶段结束的时候，这个类实例才被看做是合法的。
 
 以下是两段初始化过程，基于上述四种检查的流程
 
 直到第一阶段结束类实例才完全合法。属性只能被读取，方法也只能被调用，直到第一阶段结束的时候，这个类实例才被看做是合法的。
 
 以下是两段初始化过程，基于上述四种检查的流程：
 
 阶段 1
 指定或便捷初始化器在类中被调用；
 为这个类的新实例分配内存。内存还没有被初始化；
 这个类的指定初始化器确保所有由此类引入的存储属性都有一个值。现在这些存储属性的内存被初始化了；
 指定初始化器上交父类的初始化器为其存储属性执行相同的任务；
 这个调用父类初始化器的过程将沿着初始化器链一直向上进行，直到到达初始化器链的最顶部；
 一旦达了初始化器链的最顶部，在链顶部的类确保所有的存储属性都有一个值，此实例的内存被认为完全初始化了，此时第一阶段完成。
 
 阶段 2
 从顶部初始化器往下，链中的每一个指定初始化器都有机会进一步定制实例。初始化器现在能够访问 self 并且可以修改它的属性，调用它的实例方法等等；
 最终，链中任何便捷初始化器都有机会定制实例以及使用 slef 。
 
 
 初始化器的继承和重写
 不像在 Objective-C 中的子类，Swift 的子类不会默认继承父类的初始化器。Swift 的这种机制防止父类的简单初始化器被一个更专用的子类继承并被用来创建一个没有完全或错误初始化的新实例的情况发生。
 
 
 当你写的子类初始化器匹配父类指定初始化器的时候，你实际上可以重写那个初始化器。因此，在子类的初始化器定义之前你必须写 override 修饰符。如同默认初始化器所描述的那样，即使是自动提供的默认初始化器你也可以重写
 
 作为一个重写的属性，方法或下标脚本， override 修饰符的出现会让 Swift 来检查父类是否有一个匹配的指定初始化器来重写，并且验证你重写的初始化器已经按照意图指定了形式参数
 
 当重写父类指定初始化器时，你必须写 override 修饰符，就算你子类初始化器的实现是一个便捷初始化器。
 */



class People {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    convenience init(smallName: String) {
        self.init(name: smallName)
    }
}
// 使用convenience增加init方法
extension People {
    
}

class Teacher1 : People {
    var course : String
    
    init(name: String, course : String) {
        self.course = course
        super.init(name: "balan")
    }
    
}

class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    init() {
        self.name = "11"
        //        self.init(name: "[Unnamed]")
    }
}
class RecipeIngredient: Food {
    var quantity: Int = 0
    //     init(name: String, quantity: Int) {
    //        self.quantity = quantity
    //        super.init(name: name)
    //    }
    //
    //    override convenience init(name: String) {
    //        self.init(name: name, quantity: 1)
    //    }
}

let x = RecipeIngredient()
print(x.name)

/*
 可失败初始化器
 定义类、结构体或枚举初始化时可以失败在某些情况下会管大用。这个失败可能由以下几种方式触发，包括给初始化传入无效的形式参数值，或缺少某种外部所需的资源，又或是其他阻止初始化的情况。
 
 为了妥善处理这种可能失败的情况，在类、结构体或枚举中定义一个或多个可失败的初始化器。通过在 init 关键字后面添加问号( init? )来写。
 
 注意
 
 你不能定义可失败和非可失败的初始化器为相同的形式参数类型和名称。
 
 可失败的初始化器创建了一个初始化类型的可选值。你通过在可失败初始化器写 return nil 语句，来表明可失败初始化器在何种情况下会触发初始化失败。
 
 严格来讲，初始化器不会有返回值。相反，它们的角色是确保在初始化结束时， self 能够被正确初始化。虽然你写了 return nil 来触发初始化失败，但是你不能使用 return 关键字来表示初始化成功了。
 */
//1  比如说，可失败初始化器为数字类型转换器做实现。为了确保数字类型之间的转换保持值不变，使用 init(exactly:)  初始化器。如果类型转换不能保持值不变，初始化器失败。
let wholeNumber: Double = 12345.5
let pi = 3.14159

if let valueMaintained = Int(exactly: wholeNumber) {
    print("\(valueMaintained) conversion to int maintains value")
}else{
    print("failed")
}

struct Animal {
    let species : String
    init?(species : String) {
        if species.isEmpty {
            return nil
        }
        self.species = species
    }
}
let someCreature = Animal(species: "")
if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}else{
    print("The anonymous creature could not be initialized")
}

/*
 枚举的可失败初始化器
 你可以使用一个可失败初始化器来在带一个或多个形式参数的枚举中选择合适的情况。如果提供的形式参数没有匹配合适的情况初始化器就可能失败。
 
 下面的栗子定义一个名为 TemperatureUnit 的枚举，有三种可能的状态( Kelvin ， Celsius 和 Fahrenheit )。使用一个可失败初始化器来找一个合适用来表示气温符号的 Character 值：
 */
enum TemperatureUnit {
    case Kelvin, Celsius, Fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .Kelvin
        case "C":
            self = .Celsius
        case "F":
            self = .Fahrenheit
        default:
            return nil
        }
    }
}
//你可以使用可失败初始化器为可能的三种状态来选择一个合适的枚举情况，当参数的值不能与任意一枚举成员相匹配时，该枚举类型初始化失败
let fahrenheitUnit = TemperatureUnit(symbol: "F")
if fahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}
// prints "This is a defined temperature unit, so initialization succeeded."

let unknownUnit = TemperatureUnit(symbol: "X")
if unknownUnit == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}


/*
 带有原始值枚举的可失败初始化器
 带有原始值的枚举会自动获得一个可失败初始化器 init?(rawValue:) ，该可失败初始化器接收一个名为 rawValue 的合适的原始值类型形式参数如果找到了匹配的枚举情况就选择其一，或者没有找到匹配的值就触发初始化失败。
 
 你可以把上面的 TemperatureUnit 的栗子可以重写为使用 Character 原始值并带有改过的 init?(rawValue:) 初始化器：
 */
enum TemperatureUnit1: Character {
    case Kelvin = "K", Celsius = "C", Fahrenheit = "F"
}

let fahrenheitUnit12 = TemperatureUnit1(rawValue: "F")
if fahrenheitUnit12 != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}
// prints "This is a defined temperature unit, so initialization succeeded."

let unknownUnit1 = TemperatureUnit1(rawValue: "X")
if unknownUnit1 == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}


/*
 初始化失败的传递
 重写可失败初始化器
 */

class Document {
    var name: String?
    // this initializer creates a document with a nil name value
    init() {}
    // this initializer creates a document with a non-empty name value
    init?(name: String) {
        self.name = name
        if name.isEmpty { return nil }
    }
}
//下面这个栗子定义了一个名为 AutomaticallyNamedDocument 的 Document 类的子类。这个子类重写了 Document 类引入的两个指定初始化器。这些重写确保了 AutomaticallyNamedDocument 实例在初始化时没有名字或者传给 init(name:) 初始化器一个空字符串时 name 的初始值为 "[Untitled]" ：
//AutomaticallyNamedDocument 类用非可失败的 init(name:) 初始化器重写了父类的可失败 init?(name:) 初始化器。因为 AutomaticallyNamedDocument 类用不同的方式处理了空字符串的情况，它的初始化器不会失败，所以它提供了非可失败初始化器来代替。
class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}
//你可以在初始化器里使用强制展开来从父类调用一个可失败初始化器作为子类非可失败初始化器的一部分。例如，下边的 UntitledDocument 子类将总是被命名为 "[Untitled]" ，并且在初始化期间它使用了父类的可失败 init(name:) 初始化器：
class UntitledDocument: Document {
    override init() {
        super.init(name: "[Untitled]")!
    }
}
/*
 可失败初始化器 init!
 通常来讲我们通过在 init 关键字后添加问号 ( init? )的方式来定义一个可失败初始化器以创建一个合适类型的可选项实例。另外，你也可以使用可失败初始化器创建一个隐式展开具有合适类型的可选项实例。通过在 init 后面添加惊叹号( init! )是不是问号。
 
 你可以在 init? 初始化器中委托调用 init! 初始化器，反之亦然。 你也可以用 init! 重写 init? ，反之亦然。 你还可以用 init 委托调用 init! ，尽管当 init! 初始化器导致初始化失败时会触发断言。
 
 
 
 必要初始化器
 在类的初始化器前添加 required  修饰符来表明所有该类的子类都必须实现该初始化器：
 当子类重写父类的必要初始化器时，必须在子类的初始化器前同样添加 required 修饰符以确保当其它类继承该子类时，该初始化器同为必要初始化器。在重写父类的必要初始化器时，不需要添加 override 修饰符：
 */
class SomeClass {
    required init() {
        // initializer implementation goes here
    }
}
class SomeSubclass: SomeClass {
    required init() {
        // subclass implementation of the required initializer goes here
    }
}
/*
 通过闭包和函数来设置属性的默认值
 
 如果某个存储属性的默认值需要自定义或设置，你可以使用闭包或全局函数来为属性提供默认值。当这个属性属于的实例初始化时，闭包或函数就会被调用，并且它的返回值就会作为属性的默认值。
 
 这种闭包或函数通常会创建一个和属性相同的临时值，处理这个值以表示初始的状态，并且把这个临时值返回作为属性的默认值。
 */

class SomeClass11 {
    let someProperty: Int = {
        // create a default value for someProperty inside this closure
        // someValue must be of the same type as SomeType
        return 1
    }()
    var array : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        return table
    }()
}
/*
 注意闭包花括号的结尾跟一个没有参数的圆括号。这是告诉 Swift 立即执行闭包。如果你忽略了这对圆括号，你就会把闭包作为值赋给了属性，并且不会返回闭包的值。
 如果你使用了闭包来初始化属性，请记住闭包执行的时候，实例的其他部分还没有被初始化。这就意味着你不能在闭包里读取任何其他的属性值，即使这些属性有默认值。你也不能使用隐式 self 属性，或者调用实例的方法。
 */

//---------------------------------------------------------------------------反初始化--------------------

/*
 在类实例被释放的时候，反初始化器就会立即被调用。你可以是用 deinit 关键字来写反初始化器，就如同写初始化器要用 init 关键字一样。反初始化器只在类类型中有效。
 
 反初始化器会在实例被释放之前自动被调用。你不能自行调用反初始化器。父类的反初始化器可以被子类继承，并且子类的反初始化器实现结束之后父类的反初始化器会被调用。父类的反初始化器总会被调用，就算子类没有反初始化器。
 
 由于实例在反初始化器被调用之前都不会被释放，反初始化器可以访问实例中的所有属性并且可以基于这些属性修改自身行为（比如说查找需要被关闭的那个文件的文件名）。
 */
//-------------------------------------------------------------自动引用计数

/*
 弱引用
 弱引用不会对其引用的实例保持强引用，因而不会阻止 ARC 释放被引用的实例。这个特性阻止了引用变为循环强引用。声明属性或者变量时，在前面加上 weak 关键字表明这是一个弱引用。
 
 由于弱引用不会强保持对实例的引用，所以说实例被释放了弱引用仍旧引用着这个实例也是有可能的。因此，ARC 会在被引用的实例被释放是自动地设置弱引用为 nil 。由于弱引用需要允许它们的值为 nil ，它们一定得是可选类型。
 
 你可以检查弱引用的值是否存在，就像其他可选项的值一样，并且你将永远不会遇到“野指针”。
 */
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}
class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person?
var unit4A: Apartment?
john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

john!.apartment = unit4A
unit4A!.tenant = john

john = nil

unit4A = nil

/*
 无主引用
 和弱引用类似，无主引用不会牢牢保持住引用的实例。但是不像弱引用，总之，无主引用假定是永远有值的。因此，无主引用总是被定义为非可选类型。你可以在声明属性或者变量时，在前面加上关键字 unowned 表示这是一个无主引用。
 由于无主引用是非可选类型，你不需要在使用它的时候将它展开。无主引用总是可以直接访问。不过 ARC 无法在实例被释放后将无主引用设为 nil ，因为非可选类型的变量不允许被赋值为 ni
 
 如果你试图在实例的被释放后访问无主引用，那么你将触发运行时错误。只有在你确保引用会一直引用实例的时候才使用无主引用。
 
 还要注意的是，如果你试图访问引用的实例已经被释放了的无主引用，Swift 会确保程序直接崩溃。你不会因此而遭遇无法预期的行为。所以你应当避免这样的事情发生。
 
 */

class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}
var john1: Customer?
john1 = Customer(name: "John Appleseed")
john1!.card = CreditCard(number: 1234_5678_9012_3456, customer: john1!)

john1 = nil
//上边的例子展示了如何使用安全无主引用。Swift 还为你需要关闭运行时安全检查的情况提供了不安全无主引用——举例来说，性能优化的时候。对于所有的不安全操作，你要自己负责检查代码安全性。

//使用 unowned(unsafe) 来明确使用了一个不安全无主引用。如果你在实例的引用被释放后访问这个不安全无主引用，你的程序就会尝试访问这个实例曾今存在过的内存地址，这就是不安全操作。


/*
 无主引用和隐式展开的可选属性
 Person 和 Apartment 的例子展示了两个属性的值都允许为 nil ，并会潜在的产生循环强引用。这种场景最适合用弱引用来解决。
 
 Customer 和 CreditCard 的例子展示了一个属性的值允许为 nil ，而另一个属性的值不允许为 nil ，这也可能导致循环强引用。这种场景最好使用无主引用来解决。
 
 总之， 还有第三种场景，在这种场景中，两个属性都必须有值，并且初始化完成后永远不会为 nil 。在这种场景中，需要一个类使用无主属性，而另外一个类使用隐式展开的可选属性。
 
 一旦初始化完成，这两个属性能被直接访问(不需要可选展开)，同时避免了循环引用。这一节将为你展示如何建立这种关系。
 
 下面的例子定义了两个类， Country 和 City ，每个类将另外一个类的实例保存为属性。在这个数据模型中，每个国家必须有首都，每个城市必须属于一个国家。为了实现这种关系， Country 类拥有一个 capitalCity 属性，而 City 类有一个 country 属性：
 */
class Country {
    let name : String
    var capitalCity : City!
    init(name : String, captitalName :String) {
        self.name = name
        self.capitalCity = City(name: captitalName, country: self)
    }
}

class City {
    let name : String
    unowned let country : Country
    init(name : String, country : Country) {
        self.name = name
        self.country = country
    }
}
/*
 闭包的循环强引用
 
 */
class HTMLElement {
    
    let name: String
    let text: String?
    
    lazy var  asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized HTML")
    }
    
}
let heading = HTMLElement(name: "maxiaoliang", text: "asdfasdf")
let defaultText = "some default text"
heading.asHTML = {
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())

paragraph = nil

/*
 解决闭包的循环强引用
 
 Swift 要求你在闭包中引用self成员时使用 self.someProperty 或者 self.someMethod （而不只是 someProperty 或 someMethod ）。这有助于提醒你可能会一不小心就捕获了 self
 
 
 */
//1.定义捕获列表,捕获列表中的每一项都由 weak 或 unowned 关键字与类实例的引用（如 self ）或初始化过的变量（如 delegate = self.delegate! ）成对组成。这些项写在方括号中用逗号分开。⏫在上面

//2.弱引用和无主引用

