//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
 继承
 一个类可以从另一个类继承方法、属性和其他的特性。当一个类从另一个类继承的时候，继承的类就是所谓的子类，而这个类继承的类被称为父类。在 Swift 中，继承与其他类型不同的基础分类行为。
 
 在 Swift 中类可以调用和访问属于它们父类的方法、属性和下标脚本，并且可以提供它们自己重写的方法，属性和下标脚本来定义或修改它们的行为。Swift 会通过检查重写定义都有一个与之匹配的父类定义来确保你的重写是正确的。
 
 类也可以向继承的属性添加属性观察器，以便在属性的值改变时得到通知。可以添加任何属性监视到属性中，不管它是被定义为存储还是计算属性。
 */

//定义一个基类  任何不从另一个类继承的类都是所谓的基类。Swift 类不会从一个通用基类继承。你没有指定特定父类的类都会以基类的形式创建。

class Vehicle {
    var currentSpeed : Double = 0
    var description : String{
        return "traveling at \(currentSpeed) miles per hour"
    }
    final func makeNoise() {
        
    }
    init(speed : Double) {
        self.currentSpeed = speed
    }
}


let somVehicle = Vehicle.init(speed: 1)

/*
 子类
 
 子类是基于现有类创建新类的行为。子类从现有的类继承了一些特征，你可以重新定义它们。你也可以为子类添加新的特征。
 */

class Bicycle : Vehicle {
    var hasBasket = false
    override var currentSpeed: Double{
        didSet{
            
        }
    }
//    override func makeNoise() {
//        
//    }
}
/*
 子类可以提供它自己的实例方法、类型方法、实例属性，类型属性或下标脚本的自定义实现，否则它将会从父类继承。这就所谓的重写。
 
 要重写而不是继承一个特征，你需要在你的重写定义前面加上 override 关键字。这样做说明你打算提供一个重写而不是意外提供了一个相同定义。意外的重写可能导致意想不到的行为，并且任何没有使用 override 关键字的重写都会在编译时被诊断为错误。
 
 override 关键字会执行 Swift 编译器检查你重写的类的父类(或者父类的父类)是否有与之匹配的声明来供你重写。这个检查确保你重写的定义是正确的。
 */

/*
 阻止重写
 
 你可以通过标记为终点来阻止一个方法、属性或者下标脚本被重写。通过在方法、属性或者下标脚本的关键字前写 final 修饰符(比如 final var ， final func ， final class func ， final subscript )。
 
 任何在子类里重写终点方法、属性或下标脚本的尝试都会被报告为编译时错误。你在扩展中添加到类的方法、属性或下标脚本也可以在扩展的定义里被标记为终点。
 
 你可以通过在类定义中在 class 关键字前面写 final 修饰符( final class )标记一整个类为终点。任何想要从终点类创建子类的行为都会被报告一个编译时错误。
 */
