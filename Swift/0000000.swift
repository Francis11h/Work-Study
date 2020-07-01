



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




















