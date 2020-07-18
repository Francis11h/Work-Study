



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

An Optional is just an enum.

enum Optional <T> { // a generic type, like Array<Element> or MemoryGame<CardContent>
  case none
  case some(T)  // the some case has associated value of type T
}

u can see that it cann only have two values: "is set(some)" or "not set(none)".

"就是 可能会有 空值 nil/null 的时候的 处理办法"

Where do we use Optional? 
Any time we have a value that can sometimes be "not set" or "unspecified" or "undetermined"
e.g. the return type of firstIndex(matching: ) if the matching thing is not in the Array.
e.g. an index for the currently-face-up-card in our game when the game first starts


‘--------‘
语法

Declaring something of type Optional <T>  can be done with syntax "T?" 后头加个问号就是简写


var hello: String?               等价于     var hello: Optional<String> = .none
var hello: String? = "hello"     等价于     var hello: Optional<String> = .some("hello")
var hello: String? = nil         等价于     var hello: Optional<String> = .none







"Access control"
private(set) var cards: Array<Card>     //外部只能get不能set






‘---------------‘
  "@ViewBuilder"
‘---------------‘

a simple mechanism for supporting a more convenient syntax for lists of Views




1. To factor out 分解出 the Views we use to make the front of a Card

      @ViewBuilder
      func front(of card: Card) -> some View {
        RoundedRectangle(cornerRadius: 10)
        RoundedRectangle(cornerRadius: 10).stroke()
        ...
      }

2. can also use @ViewBuilder to mark a parameter that returns a View
        struct  GeometryReader<Content> where Content: View {
          init(@ViewBuilder content: @escaping (GeometryProxy) -> Content) {...}
        }
        the content is just a function that returns a View




‘---------------‘
  "Shape"
‘---------------‘

Shape is a protocol that inherits from View. (In other words, all Shapes are also Views)
RoundedRectangle, Circle, Capsule（一种 oval椭圆） 都是 Shape

func fill<S>(_ whatToFillWith: S) -> View where S: ShapeStyle {}
S is a don't care



when u want wo create your own shape, u need to implement this func

func path(in rect: CGRect) -> Path {
  return a Path
}

a Path that draws, Path 里面有很多函数来划线









‘-----------------‘
  "Animation动画"
‘-----------------‘

how do u make an animation "go" ?

1. Implicity, by using the view modifier  .animation(Animation)

2. Explicity, wrapping "withAnimation(Animation) { }" around code that might change things

  transitions do not work with implicit animations, only explicit animations.
  过渡                              
  .transition(AnyTransition.scale)  //很多都封装在 AnyTransition: a type-erased version of transition







‘------------------------------‘
    "Multithreading多线程"
‘------------------------------‘
It is never okay for a mobile application UI to be unresponsive to the user.

we are going to not block UI by having all the stuff that would block the UI on a different thread of execution

用 "Queue"

Main Queue        --->    UI task
Backgroud Queue   --->    long-lived, non-UI tasks


GCD (Grand Central Dispatch)
  1. getting access to a Queue
  2. plopping a block of code on a queue

-- 创建 

DispatchQueue.main                   // the queue where all UI code must be posted
DispatchQueue.global(qos: QoS)      // a non-UI queue with a certain quality of service

QoS is one of the following...
  .userInteractive      // do this fast, the UI depends on it!
  .userInitiated        // the user just asked to do this, so do it Now   用户要求做的
  .utility              // this needs to happen, but user didn't just ask for it
  .background           // maintenannce tasks(cleanups, etc.)


--把代码块放入队列 plopping a closure onto a queue

let queue = DispatchQueue.main or DispatchQueue.global(qos: )
queue.async { }
queue.sync { }
  // 同步 就会 block  所以我们真的很少用
  // the second one blocks waitting for that closure to be picked off by its queue and completed.
  // thus, u would never call .sync in UI code Because it would block the UI
  // u might call it on a background queue (to wait for some UI to finish, for example) But even that is rare

所以大多数情况 我们只用  "queue.async { /* code */}"
// always remember that .async will execute that closure "sometime later"   代码总会延缓执行
// (whenever that closure gets to "the front of" the queue you plopped it onto) 
// 只要 该闭包到达队列的 最前面，您便将其放入
// your code needs to be tolerant of that



‘--------------------‘
    "UserDefaults"
‘---------------=----‘
simplest way to store data permanently (Persistence持久化)
a persistent dictionary

only can store PropertyList 既不是 protocol 也不是 struct 仅仅是一个概念 concept 
                 it is any combination of String, Int, Bool, floating point, Date, Data, Array or Dictionary 

所以要在 UserDefaults 存任何东西 都要先把他们变成 PropertyList
用 "Codable" Protocol in Swift

用法

  let dafaults = UserDefaults.standard    // create an instance of UserDefaults
  存
  defaults.set(object, forKey: "someKey")   // object must be a PropertyList
  defaults.setDouble(37.5, orKey: "myDouble") // for convenience

  取
  let i: Int = defaults.integer(forKey: "MyInteger")
  let a: Data? = defaults.data(forKey: "MyData")
  let u: URL? = defaults.url(forKey: "MyURL")
  let strings: [String]? = defaults.stringArray(forKey: "MyString")
  ...

  let a = array(forKey: "MyArray")












‘----------------‘
    "Gesture"
‘----------------‘



1. Making your Views recognize gestures
  用 ".gesture()"
  myview.gesture(theGesture)  // theGesture must implement the Gesture Protocol

2. creating a gesture
  用 "some Gesture"
  // var theGestureName: some Gesture {
  //   return TapGesture(count: 2)
  // } 

3. Handling the Recognition of a Discrete Gesture, to do something
  用 ".onEnded{ }"
  var theGestureName: some Gesture {
    return TapGesture(count: 2)
              .onEnded{ /* do something*/} 
  } 
  ----->  可以简写 用 "on..."

  myview.onTapGesture(count: Int) { /* do something*/ }
  myview.onLongPressGesture(...) { /* do something*/ }


4. Handling non-Discrete Gesture
  
  用 ".onEnded{ value in ...}" 但是 传给我们一个value 会告诉我们手势的状态

  var theGestureName: some Gesture {
    DragGesture(...)
      .onEnded{ value in /* do something*/} 
  } 


5. 过程中改变 non-Discrete Gesture
  ".updating"

  @GestureState var myGestureState: MyGestureStateType = <starting value>

  var theGestureName: some Gesture {
    DragGesture(...)
      .updating ($myGestureState) { value, myGestureState, tranction in   // $符号很重要 不能省略
        myGestureState = /* usually something related to value*/
      }
      .onEnded{ value in /* do something*/} 
  } 


  ".onChanged {..}" 用在简单的情况 即 what u are doing is related directly to the actual finger positions // 一般用的不多















‘-----------------------‘
    "Property Wrappers"
‘-----------------------‘

即 所有的 注解样式的 @something.....

a property is actually a struct, which encapsulate some template behavior applied to the vars they wrap

@statement         making a var live in the heap
@Published         making a var publish its changes
@ObservedObject    causing a view to redraw when a published change is detected



property wrapper syntactic sugar

@Published var emojiArt: EmojiArt = EmojiArt()
        实际上是...is really just this struct..

        struct Published {
          var wrappedValue: emojiArt    //通常 wrappedValue 和 上面的 emojiArt类型一样
          var projectedValue: Publisher<EmojiArt, Never>  //Never means never fails 
        }
        //and Swift makes these vars avaliable to u

        //类型是Published it get initialized by creating a Publish Struct
        var _emojiArt: Published = Published(wrappedValue: EmojiArt()) 
        // 但是 我们不 access this _emojiArt very often 我们访问 emojiArt （不带下划线的）

        var emojiArt : EmojiArt {
          get { _emojiArt.wrappedValue }
          set { _emojiArt.wrappedValue = newValue}
        }

        // there is another  var inside the  struct:    var projectedValue

        u access this var (projectedValue) using "$"  $emojiArt
        the projectedValue's type is up to the property wrapper 


@Published:   当 wrappedValue 改变的时候 
  1. publishes the change through its projectedValue($emojiArt), which is a publisher
  2. it also invokes "objectWillChange.send()" in its enclosing "ObservableObject"

@State: 
  the wrappedValue is: anything(but almost certainly a value type)
  what it does:  store the wrappedValue in the heap: when it changes, invalidates the View.
  projectedValue($) is a "Binding" (to that value in the heap)

@ObservedObject
  the wrappedValue is: anything that implements the ObservableObject Protocol(ViewModels)
  what it does:  invalidates the View when wrappedValue does objectWillChange.send()
  projectedValue($) is a "Binding" (to the vars of the wrappedValue(a ViewModel))

@Binding
  the wrappedValue is: a value that is bound to something else
  what it does:  gets/sets the value of the wrappedValue from some other source
  what it does:  when the bound-to value changes, it invalidates the View
  projectedValue($) is a "Binding" (self; i.e. the Binding itself)

哪里用Bindings
all over the freaking危险/恐怖 place
1. Getting text out of a TextField, the choice out of a Picker         //从TextField中获取文本，从Picker中进行选择
2. Using a Toggle切换 or other state-modifying UI Elements             //使用Toggle或其他可修改状态的UI元素
3. Finding out which item in a NavigationView was chosen              //找出在NavigationView中选择了哪个项目
4, Finding out whether we're being targeted with a Drag(the isTargeted argument to onDrop)  //找出我们是否被Drag作为目标（onDrop的isTargeted参数)
5. Binding our gesture state to the .updating function of a gesture   //将我们的手势状态绑定到手势的.updating函数
6. knowing about a modally presented View's dismissal                 //了解以某种方式呈现的视图解雇

In general, breaking our Views into smaller pieces (and sharing data with them)
...


"Bindings"  are all about having a single source of the truth




---------------------

实例

Sharing @State (or an @ObservedObject's var) with other Views

struct MyView: View {
  @State var myString = "hello"
  var body: View {
    OtherView(sharedText: $myString)
  }  
} 

struct OtherView: View {
  @Binding var sharedText: String
    var body: View {
      Text(sharedText)
  }  
} 

OtherView's body is a Text whose String is always the value of myString in MyView

OtherView's sharedText is bound to MyView's myString.

所以 可以修改一处 两处都会改变




--------------------

create a Binding to a constant value with Binging.constant(value)
e.g. OtherView(sharedText: .constant("Howdy"))   will always show Howdy in OtherView





--------------------‘
    "Publisher"
--------------------‘


It is an object that emits values and possibly a failure object if it fails while doing so

"Publisher<Output, Failure>"
Output is the type of the thing this Publisher publishes
Failure is the type of the thing it communicates if it fails while trying to publish

e.g.

Listening(subscribing) to a publisher

1.  用 .sink() 函数  simply execute a closure whenever a Publisher publishes

          cancellable = myPublisher.sink (
              receiveCompletion: { result in ...},      // result is a Completion<Failure> enum
              receiveValue: { thingThePublisherPublishes in ...}
          )

2. a View can listen to a Publisher too

    .onReceive(publisher) { thingThePublisherPublishes in
        // do whatever u want with thingThePublisherPublishes
    }

    .onReceive will automatically invalidate your View(causing a redraw)



Publisher 从哪里来？

1. " $ " in front of vars marked @Published
2. "URLSession" 's  dataTaskPublisher (publishes the Data obtained from a URL)
3. "Timer's publish" 's publish(every: ) (periodically publishes the current date and time as a Date)
4. "NotificationCenter" 's publisher(for: ) (publishes otifications when system events happen)

























