##UIGraphicsBeginImageContext

UIGraphicsBeginImageContext(size) 相当于 UIGraphicsBeginImageContextWithOptions（size， NO， 1.0）

size:新创建的位图上下文的大小
opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
scale—–缩放因子 iPhone 4是2.0，其他是1.0。虽然这里可以用[UIScreen mainScreen].scale来获取，但实际上设为0后，系统就会自动设置正确的比例了


* UIKit：最常用的视图框架，封装度最高，都是OC对象

* CoreGraphics：主要绘图系统，常用于绘制自定义视图，纯C的API，使用Quartz2D做引擎

* CoreAnimation：提供强大的2D和3D动画效果

* CoreImage：给图片提供各种滤镜处理，比如高斯模糊、锐化等

* OpenGL-ES：主要用于游戏绘制，但它是一套编程规范，具体由设备制造商实现

##CGContextSaveGState与CGContextRestoreGState的作用

 使用Quartz时涉及到一个图形上下文，其中图形上下文中包含一个保存过的图形状态堆栈。在Quartz创建图形上下文时，该堆栈是空的。CGContextSaveGState函数的作用是将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的描画操作，但不影响存储在堆栈中的拷贝。在修改完成后，您可以通过CGContextRestoreGState函数把堆栈顶部的状态弹出，返回到之前的图形状态。这种推入和弹出的方式是回到之前图形状态的快速方法，避免逐个撤消所有的状态修改；这也是将某些状态（比如裁剪路径）恢复到原有设置的唯一方式。
 
 奇偶 、零点   [网址](https://www.jianshu.com/p/36a5659cebe4)

