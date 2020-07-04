



"初始界面"
‘--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------‘


// 等于 其他语言的 include or import 用于引包

import SwiftUI

// 类似 C C++ 的 struct 但是不一样的是 
// 它可以含有 变量 variable 方法 functions 行为 behaviors

struct ContentView: View {
	var body: some View {
		Text("Hello There, World!")
	}
}



// ContentView 是我们自己的identifier,  : View 是Swift's 的identifier 
// : View  代表的是 ContentView behaves like a view 
// 不是ood 而是 functional programming
// 一个 View 是一个 长方形 ContentView 代表的是 整个手机屏幕这个大的长方形


// var 是一个 property means a var innside a struct or a class
// body 是我们自己取得变量名字
// : some View  这里 是 这个变量的类型


// some View 是一个特殊的类型  
// it means the type of this variable this property is any type, any struct, 
//									   as long as it behaves like a View


可以把 views 当成 lego 乐高的积木 
Text 可以当成是 brick lego 其他的 可能会有 组合combiners,  View combiners


var body: some View {

}

这里的大括号 表示 its value is not stored in memory, instead its var is computed
每次 call 的时候 都会重新计算

同时 return 省略了  本来应该是 // return Text("Hello There, World!")










// 这是 所有的 swift 文件 自带的 

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}








"基本数据类型"
‘--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------‘

RoundedRectangle	

RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
// cornerRadius: 10.0  something was inherited from OC 由OC继承过来的 一一对应的关系
// this pattern of calling a function on a View or a Shape to return another View is very common 

‘-------------‘

ZStack 是一种 view （one of the "some view"）
ZStack is just a struct, it behaves like a view 

the list of the views to stack on top of each other 
就是 一层一层的叠起来 先写的在下面

标准创建模式 
	return ZStack(content: {
		//    这里面放的 都是 return 的 View 们
		// 	  RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
	 	//    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
	 	//    Text("👻")
	})



‘-------------‘

return forEach(参数 1. iteratablething, 参数 2. a ZStack)


return ForEach(0..<4, content: { index in

   	// ZStack(content: {
    //    RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
    //    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
    //    //stroke = 擦除 = 由黑变白
    //    Text("👻")
   	// })
})



‘-------------‘
	"HStack"
‘-------------‘

//return HStack(content: {
		// ForEach 
		// ZStack
//})

//

ZStack arranges things from back to ground
HStack arranges things horizontally

HStack 还有个 spacing 的参数 来控制 里面的 东西的 分布距离




//-------------------------------------------------------------------------------
//struct ContentView: View {
//    var body: some View {
//        HStack (content: {
//            ForEach(0..<4, content: { index in
//               ZStack(content: {
//                   RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
//                   RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
//                   //stroke = 擦除 = 由黑变白
//                   Text("👻")
//               })
//            })
//        })
//           .padding()
//           .foregroundColor(Color.orange) // put modifiers for these combiner Views on a line by themselves
//           .font(Font.largeTitle)  // make the emoji larger
//    }
//}



//-------------------------------------------------------------------------------
可以把 小括号 都放到一起 进行 简化/干净的写法  省去很多 不必要的 content: 

struct ContentView: View {
    var body: some View {
        HStack () {
            ForEach(0..<4) { index in
               ZStack() {
                   RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                   RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                   //stroke = 擦除 = 由黑变白
                   Text("👻")
               }
            }
        }
           .padding()
           .foregroundColor(Color.orange) // put modifiers for these combiner Views on a line by themselves
           .font(Font.largeTitle)  // make the emoji larger
    }
}






"思想"
‘--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------‘


‘-------------‘
	"封装"
‘-------------‘

//-------------------------------------------------------------------------------
// 更加优化的写法 之 封装 encapsulation

struct ContentView: View {
    var body: some View {
        HStack() {
            ForEach(0..<4) { index in
               CardView()		// 　这里创建 实例
            }
        }
           .padding()
           .foregroundColor(Color.orange) // put modifiers for these combiner Views on a line by themselves
           .font(Font.largeTitle)  // make the emoji larger
    }
}


//这里 封装 ZStack 到一个类
struct CardView: View {
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
            //stroke = 擦除 = 由黑变白
            Text("👻")
        }
    }
}





‘-----------‘
  "终极简写"
‘-----------‘


// 不再需要这个  下面代替了
func createCardContent(pairIndex: Int) -> String {
   return "😂"
}

1. 复制除了名之后所有的 到 "cardContentFactory:" 之后

private var model: MemoryGame<String> =
      MemoryGame<String>(numberOfPairsOfCards: 2, cardContentFactory: (pairIndex: Int) -> String {
          return "😃"
      })   
      // inlining of functions in Swift is called a closure

2. 
   2.1 删去 { 改为 in  
   2.2 然后把 { 放到 : 后

private var model: MemoryGame<String> =
      MemoryGame<String>(numberOfPairsOfCards: 2, cardContentFactory: { (pairIndex: Int) -> String in
          return "😃"
      })   
      // inlining of functions in Swift is called a closure


3. 因为 后面有声明 　(Int) -> CardContent) 所以可以省略  "1.类型的声明Int 2.返回符号 -> 3.返回类型 String"


private var model: MemoryGame<String> =
      MemoryGame<String>(numberOfPairsOfCards: 2, cardContentFactory: { (pairIndex) in
          return "😃"
      }) 
  

4.  同时 小括号 和 return 都可以省

private var model: MemoryGame<String> =
      MemoryGame<String>(numberOfPairsOfCards: 2, cardContentFactory: { pairIndex in "😃" }) 

5. 由于 cardContentFactory: { pairIndex in "😃" } 是最后一个参数 类比 ZStack HStack
   也可类比   ForEach(0..<4) { index in
               CardView()   
            }

    就是 可以省去 keyword, (get rid of the keyword)
    同时 put the curly brace thing outside, floating outside 

    即 前面先写() 再跟 { ... }

private var model: MemoryGame<String> =
      MemoryGame<String>(numberOfPairsOfCards: 2) { pairIndex in "😃" }



6.  由于 我们总是 返回 😃
    所以 pairIndex 这东西没啥用 但是不能删 但是可以简写 mark it with an underbar

private var model: MemoryGame<String> =
      MemoryGame<String>(numberOfPairsOfCards: 2) { _ in "😃" }



















‘-------------‘
	"MVVM"
‘-------------‘

MVVM is a design paradigm, is a code organizing model

Model-View-ViewModel is different from MVC that the UIKit(old-style-ios) uses.

1. Model 里是写逻辑的 各种 比如 当我选卡牌时 怎么算match 如果mismatch该咋么办
		写的是 “The truth”
		encapsulate the data annd the logic

2. View 就是 Model 当前的状态state 拿过来并且展示出来

3. ViewModel 相当于一个解释器 interpre
		可以简化 Model出的请求 逻辑 以便传输给view ter


‘----------------------------‘
	"Type system in Swift"
‘----------------------------‘

6种 

struct
class
protocol
"Don't Care" type(aka generics)
enum
functions


最大的区别
struct is a value type 
class is a reference type 

Generics: array 算一种
    var a = Array<Int>()
    a.append(5)
    a.append(20)


functions:  举个例子 (Int, Int) -> Bool

  func square(operand: Double) -> Double {
    return operand * operand
  }

  operation = square
  let result1 = operation(4)










‘-------------‘
  "reactive"
‘-------------‘
ViewModel
class EmojiMemoryGame: ObservableObject {   // ObservableObject 这个 constrain(即 protocol) 用来实现 reactive 即实时更新
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()   // property wrapper 即自动 send
    ......
}


View

struct EmojiMemoryGameView: View {
    //@ObservedObject   when it seens this viewModel publishing, it redraws the view
    @ObservedObject var viewModel: EmojiMemoryGame  
    ......
}








‘-------------‘
  "protocol"
‘-------------‘

类似于 java 中的 接口
有 functions 和 var 但是没有实现 implementation

举例样例
protocol Moveable {
  func move(by: Int)
  var hasMoved: Bool { get }
  var distanceFromStrat: Int { get set}
}

the { } on the vars just say whether it's read only or a var whose value can also be set

‘-------------------------------------------------------------‘
any other type can claim 声明 to implement protocol(Moveable)

struct 可以实现 举例
struct PortableThing: Moveable {
  // must implement move(by: ), hasMoved, and distanceFromStrat here
}

‘--------------------‘
同时 protocol 可以继承

先用 Vehicle继承 Moveable

protocol Vehicle: Moveable {
  var passengerCount: Int { get set }
}

再用class 实现

class Car: Vehicle {
  // must implement move(by: ), hasMoved, and distanceFromStrat here
}


‘-------------------‘
可以实现 多个 protocol

class Car: Vehicle, Impoundable, Leasable {
  // must implement move(by: ), hasMoved, and distanceFromStrat here
  // and also must implement any funs/vars in Impoundable protocol & Leasable protocol
}



‘-------------------‘
可以拓展补充 extension

extension Vehicle {
  func registerWithDMV() { /* implementation here */}
}

Now all vehicles can be registered With DMV



‘-------------------------‘
  "Generics and Protocol"
‘-------------------------‘

when we combine these Don't Care type(aka generics) with constrain and gain, we get superpowers.
If we had a protocol like this...

protocol Greatness {
  func isGreaterThan(other: Self) -> Bool
}
(the type Self means the actual type of the thing implementing this protocol)
...then we could add an extension to Array like this...

extension Array where Element: Greatness {
   var greatest: Element {
     // for-loop through all the Elements
     // which (inside the extension) we know each implements the Greatness Protocol
     // and figure out which one is greatest by calling isGreaterThan(other: ) on them
     return the greatest by calling isGreaterThan on each Element
   }
}






‘---------‘
  "enum"
‘---------‘
it can only have discrete states离散状态
it is a value type, so it is copied as it is passed around

与其他语言不同的是 每个case可以有一些其他附加的属性

enum FastFoodMenuItem {
  case hamburger(numberOfPatties: Int)
  case fries(size: FryOrderSize)
  case drink(String, ounces: Int)   //ounces盎司
  case cookie
}


A enum's state is checked with a switch statement(i.e. 不是用if)...

var menuItem = FastFoodMenuItem.hamburger(patties: 2)

switch menuItem {
  // case FastFoodMenuItem.hamburger: print("burger")   // swift 可以 infer 可以简写
  case .hamburger: print("burger")
  case .fries: break          //如果不想继续了 
  case .drink: print("drink")
  default: print("other")     //默认值
  ...
}






‘---------------‘
  "Layout 布局"
‘---------------‘


CGFloat
CGSize
CGPoint

GeometryReader  { geometry in 
..
}









‘---------------‘
  "Optional"
‘---------------‘













