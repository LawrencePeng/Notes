title: 《Effective C++》读书笔记
tag: [Effective, C++, 读书, 笔记, 编程]
category: 读书
------

# 前言

《Effective C++》是Effective系列的名数之一。说来Effective Series的名书其实有很多，全都是一些简短的条例构成了书的大部分内容。这本书也是如此，其副标题是改善程序与设计的55个具体做法，说完这个基本大家都懂了。本书质量很高，是C++领域的必读「入门」书籍。之所以说是入门，因为C++实在是体系过于庞大，没几个人敢说自己是精通C++的。不过对于精通这个词本来就是没有界定范围的，学会了语法（对于C++依然很难)，做了几个小Project很多大学生就敢往简历中填上精通XXX了，说来也是怪事。如果你对C++感兴趣，喜欢用它作为工具语言，那么本书不妨一读。这次的笔记，为了防止出现篇幅过大的情况，仅仅会对一些重要的点进行说明，其他的守则都会简要的说明下结论。

# 笔记

## 让自己习惯C++

### 视C++为一个语言联邦

接上前言的话，很多人敢写上自己精通XXX，其实也许可能并非如此。拿C++来说，就是一个很好的例子。大部分大学教授的C++，其实只能算是C with Class。它虽然是C++的初衷，却不是C++的现在了。C++更应该被认为是一个多重泛型编程语言，其同时支持面向过程、面向对象、函数式、泛型、元编程范式。为什么C++会支持如此多的范式呢？因为C++社区一直认为语言只是工具，它不应该成为程序员思想上的限制。所以为了做到如此，它必须海纳百川。事实上这些范式在C++上融合的很不错，这也是我很喜欢C++的原因，特别是Modern C++的出现，让我这种普通人，也能很无害地使用C++后，我在很多项目中都更愿意使用C++。

正因为C++如此复杂，如果你选择使用C++的时候，请一定选取一个子集进行工作，否则，除非你是C++大牛，估计要花费大量的时间用于了解C++。这对于一个工程来说，显得太过于昂贵。

Note: C++高效编程守则视状况而变化，取决于你使用C++的哪一部分。

### 尽量以const，enum，inline替换 #define

这一点没什么好讲的，尽量使用const而非#define是一个C++程序员的思维方式。早期的C程序中没有常量的概念，所以很多人只能使用预处理器来Hack，如今，你不需要遭受如此苦楚。即使是C，也是如此。

另一个很多人使用#define的原因是想要借用其来定义函数以减少函数调的overhead。当然这里面缺陷多多，就不展开了。C++程序员有一种又让马儿跑，还让马儿不吃草的解决方案。内联函数，这种函数能在编译期被编译器优化，自然也没有了函数调用的overhead，所以，学会用C++的思维思考，从弃用#define开始。

Note: 

- 对于单纯变量，最好以const对象或enums替换#defines
- 对于形似函数的宏（macros）买最好用inline函数替换#defines

### 尽可能使用const

const的好处并不仅是替代预处理器的一部分工作而已。实际上const的作用极其强大。

const可以表示常量性，无论是对于常量还是指针本身，使用const都能在语义上实现常量性。

如果你要重载 	\*运算符，请注意一定要让返回值被const约束，因为这是一个自定义类应该于基本类型的行为一致。我相信你并不希望 `(a*b) = c；`被赋值吧。。。

const用于成员函数可以标示它们不会修改成员的值。然而因为指针这种概念的存在，这使得对于常量性的探究很容易进入一个迷思之中（即指针本身不变，而指针所指的值改变算不算改变。）。

如果我们使用mutable，就能释放掉non-static成员变量的bitwise constness约束。

如果你的成员函数中需要定义const和非const版本的。那么你最好通过让非const版本的函数来调用const版本的成员函数来实现。实际上，这种代理太过于常见，以至于C++的新版中都出现了Constructor的语法糖。。。


Note:

- 将某些东西声明为const可帮助编译器勘测处错误用法。const可被施加于任何作用域内的对象、函数参数、函数返回类型、成员函数本体。
- 编译器强制实施bitwise constness，但你编写程序时应该使用『概念上的常量性』。
- 当const和non-const成员函数有着实质等价的实现时，令non-const版本调用const版本可避免重复。

### 确定对象在使用前已向被初始化

这点已经是老调重弹了，不过这本书弹出了新意。

让我们考虑类型的问题。

对于内置类型，初始化 === 赋值。

对于自定义类型，成员变量的初始化则是在进入构造函数本体之前。其按照变量在类中定义的顺序分别在构造器形参列表中被初始化。

不同编译单元内定义的non-local static对象的初始化顺序无法确定。这意味着你最好使用local static 来完成初始化。

Note:

- 为内置型对象进行手工初始化，因为C++不保证初始化它们。（联系其他语言）
- 构造函数最好使用成员初值列，而不要在构造函数本体内使用赋值操作。初值列列出的成员变量，其排列次序应该和它们在class中的声明次序相同。
- 为免除『苦啊编译单元只初始化次序』问题，请以local static 对象替换non-local static 对象。

## 构造/析构/赋值操作

### 了解C++默默编写并调用哪些函数

Note: 当你简单的写来一个class 定义的时候，编译器其实为你生成了一个default构造函数，一个default析构函数，一个default拷贝函数，一个拷贝运算符的重定义。

### 如果不想使用编译器自动生成函数，就该明确拒绝

Note: 为驳回编译器自动提供的机能，可将对应的成员函数声明为private并且不予实现。使用像Boost.noncopyable这样的base class也是一样的做法。


### 为多态基类声明virtual析构函数

太过于基础，不说明。

Note: 
- polymorphic（带多态性质的）base class 应该声明一个virtual析构函数。如果class带有任何virtual函数，它就应该拥有一个virtual析构函数。
- Classes 的设计目的如果不是为了base classes使用，或不是为了具备多态性，就不该声明virtual析构函数。

### 别让异常逃离析构函数

简要的说，就是不要忘记去处理掉异常，析构函数就是C++为这种场景定制的功能。

3个办法可以参考:

1. 调用abort完成
2. 吞掉异常
3. 重新设计接口，使用户有机会对可能出现的问题作出反应。

Note: 

- 析构函数绝对不要吐出异常。路过一个被析构函数调用的函数可能抛出异常，析构函数应该不做任何异常，然后吞下它们或结束程序。
- 路过客户需要对某个操作函数运行期间抛出的异常做出反应，那么，class应该提供一个普通函数(而非在析构函数中)执行该操作。

### 绝不在构造和析构过程中调用virtual函数

简单的说base class构造和析构期间，virtual函数不是virtual函数。其类型不是derived class的类型。

有什么方案可以解决呢？

一种可行方案是讲被调用函数改为non-virtual，然后要求derived class构造/析构函数传递必要信息给构造函数。

Note: 在构造和析构期间不要调用virtual函数，因为这类调用从不下降至derived class（比起当前执行构造函数和析构函数的那层）。

### 令 operator=返回一个reference to **this*

Note: 令赋值操作符反复一个reference to *this。

### 在operator=中处理『自我赋值』

你又没想过可能出现 x = x；的情况。

所以在赋值操作符的定义中，请不要忘了处理『自我赋值』。

很多人可能会直接写`if (*this == anoVal)` 这当然管用。

但是，如果我们能够处理异常安全性的问题，这个问题依然会得到解决。所以为什么不直接处理异常安全性问题呢？这一劳永逸。

处理异常安全性的方法可以是在生成新对象前不要删除指针，或者是使用copy and swap技术。

Note: 

- 确保当对象自我赋值时operator=有良好行为。其中的技术包括比较『来源对象』和『目标对象』的地址、精心周到的语句顺序、以及copy-and-swap。
- 确定任何对象如果操作一个以上的对象，而其中多个对象是同一个对象时，其行为依然正确。

### 复制对象时勿忘其每一个成分

这句话说起来简单，做起来没那么容易。

当你决定自己实现copy语义的时候，就要确保兑现自己处理所有部分的承诺。-- 恩，喜欢C++的程序员都是很有责任心的，妹子们看到了么? hhh

当然，还有基类的所有成员也别忘了。

Note:
- Copying函数应该确保复制『对象内所有成员变量』及『所有base class成分』。
- 不要尝试以某个copying函数实现另一个copying函数。应该将共同机能放进第三个函数，并由两个coping函数共同调用。

## 资源管理

本章为该书新填内容。

### 以对象管理资源

对象的生命周期管理可不是件容易的事，好在在C++的世界中，我们不像C只能徒手干活。我们拥有一些管理对象。使用它们将让你少去关心很多事情。

这一想法的关键思路：

- **获得资源后立即放进管理对象类。**
- **管理对象运用析构函数确保资源被释放。**

如果你使用C++11，那么或许该考虑下std::unique_ptr来替换std::auto_ptr。它避免了auto_ptr的很多缺陷。

std::shared_ptr已经很不错了，如果是对于数组的场景，或许你应该看看boost::scoped_array。

### 在资源管理类中小心copying行为

毫无疑问，这是个复杂的问题。不过通常做法无非几种，按实际情况使用不同方案就好:

- 禁止复制 -- Boost::nonopyable欢迎你。私有继承一下就好。
- 对底层资源祭出『引用计数法』 -- share_ptr和ObjectiveC欢迎你（Joke）。
- 复制底层资源 -- DeepCopy大法好。
- 转移底部资源的拥有权 -- 能用C++11的话就用std::unique_ptr吧。

Note: 

- 复制RAII对象必须一并复制它所管理的资源，所以资源的copying行为决定RAII对象的copying行为。
- 普遍而常见的RAII class copying行为是 抑制copying、实行Reference Counting。不过其他行为都可能被实现。

### 在资源管理类中提供对原始资源的访问

Note: 

- APIs往往要求访问原始资源，所以每一个RAII class 应该提供一个『取得其所管理的资源』的方法。
- 对原始资源的访问可能经由经由显式转换或隐式转换。一般而言显式转换比较安全，但隐式转换比较方便。

### 成对使用new和delete时要采取相同形式

Note: 如果你在new表达式中使用[]，必须在相应的delete表达式中也是用[]。如果你在new表达式中不使用[]，一定不要再对应的delete表达式中使用[]。


### 以独立语句将new*ed*对象置于智能指针

这一条是我没想到的，其实Java也有这个东西，居然那么久都没能自己琢磨出来，惭愧惭愧。

有时候你可能会为了偷懒，这样写:`xxxFunction(SmartPointer<typeof something>(new something), anoFuntion())`。这样写有什么问题么？

其实，因为有指令重排序的原因，很可能，anoFunction的调用会发生在something构建和传参的间隔内。如果anoFunction出现异常，那么new出来的something就会资源泄露。。。

所以别偷懒，写成两行吧。

Note: 以独立语句将need对象储存于智能指针中。如果不这么做，一旦异常被抛出，有可能导致难以察觉的资源泄露。


## 设计与声明

### 让接口容易被正确使用，不易被误用

接口是用户与你的类打交道的主要方式。所以接口一定要设计的合理。

一个合理的接口应该尽量避免用户可能会犯的错误。

避免无端与内置类型不兼容，理由是为了提供行为一直的接口。很少有其他性质比得上『一致性』比得上『一致性』更能导致『接口容易被正确使用』，也很少有其他性质比得上『不一致性』更加剧接口的恶化。

任何接口如果要求客户必须记得某些事情，就是有着『不正确使用』的倾向，因为客户可能会忘记做那件事。

为避免资源泄露，可以将职责交给智能指针。

shared_ptr支持指定删除器。这能够防止DLL问题。(Windows幺蛾子真不少)

Note:

- 好的接口很容易被正确使用，不容易被误用。你应该在你的所有接口中努力达成这些性质。
- 『促进正确使用』的方法包括接口的一致性，以及与内置类型的行为兼容。
- 『阻止误用』的办法包括建立新类型、限制类型上的操作，束缚对象值和消除客户的资源管理责任。
- shared_ptr支持定制型删除器。这可防止DLL问题，可被用来自动解除互斥锁。

### 设计class犹如设计type
几乎每个class都要求你面对一下提问:

- 新的type的对象应该如何被创建和销毁
- 对象的初始化和对象的赋值该有怎么样的差别？
- 新type的对象如果被passed by value，意味着什么？
- 什么事新type的『合法值』？
- 你的新type需要配合某个继承图系吗？
- 你的新type需要怎么样的转换？
- 什么样的操作符和函数对此新type而言是合理的？
- 什么样标准函数应该被驳回？
- 谁该取用新type的『未声明借口』
- 你的新type有多么一般性？
- 你真的需要一个新的type么？

Note: Class的设计就是type的设计。在定义一个新type之前，请确定你已经考虑过本条款覆盖的所有讨论主题。

### 宁以pass-by-reference-to-const替换pass-by-value

Note: 

- 尽量以pass-by-reference-to-const替换pass-by-value。前者通常比较高效，并可避免切割问题。
- 以上规则并不适用于内置类型，以及STL的迭代器和函数对象。对它们而言，pass-by-value往往比较合适。

### 必须返回对象时，别妄想返回其reference

Note: 绝不要返回pointer或reference指向一个local stack对象，或返回reference指向一个heap-allocated对象，或返回pointer或reference指向一个local static对象而有可能同时需要多个这样的对象。（有可能，请使用C++11的move语义）

### 将成员变量声明为private

Note: 

- 切记将成员变量声明为private。这将赋予客户访问数据的一致性、可细微划分访问控制、允诺约束条件获得保证，并提供class作者以充分的实现弹性。
- protected并不比public更具封装性。

### 宁以non-member、non-friend替换member函数

member函数带来的封装性比non-member函数低。

愈多东西被封装，愈少人可以看到它而愈少人看到它，我们就有愈大的弹性去变化它，因为我们的改变仅仅直接影响看到变化的那些人事物。

friends函数对class private成员的访问权力和member函数相同，因此两者对封装的冲击力道也相同。

Note: 宁可拿non-friend non-member替换member函数。这样做可以增加封装性、包裹弹性(packaging flexibility)和机能扩充性。

### 若所有参数皆需类型转换，请为此采用non-member函数

std::swap函数的实现中是使用了复制构造函数来完成交换。正因如此，其效率可能会很底下。所以，你有可能会想要重写swap函数。这是件好事，但请不要忘了处理异常。

如果你做了一个member版本的swap，你应该也做一个non-member版本的来调用它。对于class，请使用模板特化。这有助于覆盖std::swap。

Note:

- 当std::swap对你的类型效率不高时，提供一个swap成员函数，并确定这个函数不抛出异常。
- 如果你提供一个member swap，也该提供一个non-member swap用来调用前者。对于class，也请特化std::swap
- 调用swap时应调用std::swap使用using声明式，然后调用swap并且不带任何『命名空间资格修饰』。
- 为『用户定义类型』进行std templates全特化是最好的，但千万不要尝试在std内加入某些对std而言全新的东西。

## 实现

### 尽可能延后变量定义式的出现时间

Note: 尽可能延后变量式的出现。这样做可增加程序的清晰度并改善程序效率。

### 尽量少做转型动作

C++提供了多种转型的方式。一部分是来自C风格的转型。另一种是C++风格的转型。

应该优先选择C++风格的转型,因为它们更具可读性，并且拥有编译期的边界检查特性。

C++风格的转型包括:

- const_cast -- 去除对象的常量性描述。
- dynamic_cast -- 用于安全向下转型。性能极差。
- reinterpret_cast -- 执行低级转型。
- static_cast 强迫隐式转型

Note:

- 如果可以，尽量避免转型，特别是在注重效率的代码中避免dynamic_cast*s*。如果有个设计需要转型操作，试着发展无需转型的替代设计。
- 如果转型是必要的，试着将他隐藏于某个函数背后。客户随后可以调用该函数，而不需将转型放进他们自己的代码内。
- 宁可使用C++-style(新式)转型，不要使用旧式转型。前者很容易辨识出来，而且也比较有着分门别类的职掌。

### 避免返回handles指向对象内部成分

让我们回到const函数的那一节，我们说因为有指针这种概念的出现，会导致const可能不像const。所以引出来这一条也不奇怪了。

函数返回reference指向private内部数据，调用者于是通过这些reference更改内部数据。

返回一个『代表级别较低』的成员函数的handle，随之而来的便是『降低对象封装性』handle的风险。

通常我们认为，对象的『内部』就是指它的成员变量，但其实不被公开使用的成员函数（也就是被声明protected或private者）也是对象『内部』的一部分。

这意味你绝对不该令成员函数返回一个指针访问『访问级别较低』的成员函数。如果你那么做，后者的实际访问级别就会提高如同前者。

Note: 避免返回handles(包括reference、指针、迭代器)指向对象内部。遵守这个条款可增加封装性，帮助const成员函数的行为像个const，并将发生『虚调号码牌』的可能性降为最低。

### 为『异常安全』而努力是值得的

异常被抛出时，带有异常安全性的函数会:

- 不泄露任何资源
- 不允许数据败坏

异常安全函数提供一下三个保证之一:

- 基本承诺 -- 如果异常被抛出，程序内的任何事物仍然保持有效状态下。
- 强烈保证 -- 如果异常被抛出，程序状态不改变。 -- 类比事务。
- 不抛掷保证 -- 承诺绝不抛出异常，因为它们总是能够完成原先承诺的功能。

可以使用copy and swap提供强烈保证。

Note:

- 异常安全函数即时发生异常也不会泄露资源或允许任何数据结构败坏。这样的函数区分为三中可能的保证:基本型、强烈型、不抛异常型。
- 『强烈保证』往往能够以swap and copy实现出来，但『强烈保证』并非对所有函数都可实现或具备现实意义。
- 函数提供的『异常安全保证』通常最高等于其所调用的各个函数的『异常安全保证』中的最弱者。

### 透彻了解inlining的里里外外

inline会导致代码膨胀问题。

inline只是对编译器的一个申请，不是强制命令。

inline函数一般被置于头文件中，因为大多数建置环境在编译过程中进行inlining。

所有virtual函数都无法inline。

构造函数和析构函数往往是inlinng的糟糕候选人。

Note:


- 将大多数inlining限制在小型、被频繁调用的函数身上。这可使日后的调试过程和二级制升级更容易，也可使潜在的代码膨胀问题最小化，使程序的速度提升机会最大化。
- 不要只因为function template出现在头文件，就将他们声明为inline。


### 将文件间的编译依存关系降至最低

要点在于将接口和实现分离。

分离的关键在于以『声明的依存性』替换『定义的依存性』。

如果只用Object reference 或 Object pointer可以完成任务，就不要使用Object。

如果能够，尽量以class声明式替换class定义式。

为声明式和定义式提供不同的头文件。

其中有两种方式：使用handle Class、使用Interface Class。

Note:

- 支持『编译依存性最小化』的一般构想是：向依以声明式，不要相依以定义式。基于此构想的两个手段是Handle classes 和 Interface classes。
- 程序库头文件应该以『完全且仅有声明式』的形式存在。这种做法不论是否涉及templates都适用。


## 继承与面向对象设计

### 确定你的public继承塑模出is-a关系

Note: 『public继承』意味is-a。适用于base classes 身上的每一件事情一定也适用于derived classes身上，因为每一个derived class 对象也都是一个base class对象。

### 避免遮掩继承而来的名称

C++的名称遮掩规则所做的唯一事情就是：遮掩名称。至于名称是否应和相同或不同的类型，并不重要。

如果你继承base class 并加上重载函数，而你又希望重新定义或覆写其中一部分，那么你必须为那些原本被遮掩的每个名称引入一个using声明式，否则某些你希望的名称会被遮掩。

Note: 

- derived classes 内的名称会遮掩base classes内的名称。在public继承下从来没有人希望如此。
- 为了让被遮掩的名称再见天日，可使用using声明式或转交函数。

### 区分接口继承和实现继承

public继承意味着

- 成员函数的接口总会被继承
- 声明一个pure virtual函数的目的是为了让derived classes 只继承函数接口。
- 声明简朴的impure virtual函数的目的，是让derived classes 继承该函数的接口和缺省实现。
- 声明non-virtual函数的目的是为了令derived class 继承函数的接口和一份强制性实现。

Note: 

- 接口继承和实现继承不同。在public继承之下，derived class总是继承base class的接口。
- pure virtual函数只具体指定接口继承。
- 简朴的(非纯)impure virtual函数具体指定接口继承及缺省实现继承。
- non-virtual函数具体制定接口继承以及强制性实现继承。

### 考虑virtual函数之外的其他选择

virtual函数或许很不错，不过一个优秀的程序员有多种方式可以替换它。

文中讲了3种方式，实现大家可以自行查阅：

- 籍由Non-Virtual Interface手法实现Template Method模式 -- 通过non-virtual函数间接调用virtual函数，更加灵活
- std::function实现Strategy模式 -- 也是C++11中的特性。非常推荐大家了解。
- 古典的Strategy模式 -- 设计模式的一种。

摘要：

- 使用non-virtual interface(NVI)手法，那是Template Method设计模式的一种特殊形式。它以public non-virtual 成员函数包裹较低访问性的virtual函数。
- 将virtual函数替换为『函数指针成员变量』，这是Strategy设计模式的一种分解表现形式。
- 以std::function成员变量替换virtual函数，因而允许使用任何可调用吴(callable entity)搭配一个于需求的签名式。这也是Strategy设计模式的某种形式。
- 将继承体系内的virtual函数替换为另一个继承体系的virtual函数。这是Strategy设计模式的传统表现手法。


Note:

- virtual函数的替代方案包括NVI和Strategy设计模式的多种形式。NVI手法自身是一个特殊形式的Template Method设计模式。
- 将机能从成员函数移到class外部函数，带来的一个缺点是，非成员函数无法访问class的non-public成员。
- std::function对象的行为就像一般函数指针。这样的对象可接纳『与给定之目标签名式兼容』的所有可调用物。

### 绝不重新定义继承而来的non-virtual函数

Note: 如标题

### 绝不重新定义继承而来的缺省参数值

Note: 绝对不要重新定义一个继承而来的缺省参数值，因为缺省参数值都是静态绑定，而virtual函数--你唯一应该覆写的东西——却是动态绑定。

### 通过复合塑模出has-a或根据某物实现出

Note:

- 复合的意义和public继承完全不同
- 在应用域，复合意味着有一个。在实现域，复合意味着is-implemented-in-term-of

### 明智而审慎地使用private继承

Note：

- Private继承意味着is-implemented-in-term-of。它通常比复合的级别低。但是derived class 需要访问protected base class的成员，或需要重新定义继承而来的virtual函数时，这么设计师合理的。
- 和复用不同，private继承可以造成empty base最优化。这对致力于『对象尺寸最优化』的程序库开发者而言，可能很重要。

### 明智而审慎地使用多重继承

Note:

- 多重继承比单一继承复杂。它可能导致新的歧义性，以及对virtual继承的需要。
- virtual继承会增加大小、速度、初始化复杂度等等成本。如果virtual base classes不带任何数据，监视最具有使用价值的情况
- 多重继承的确有正当用途。其中一个情节设计『public继承某个Interface class』和『private继承某个协助实现的class』的两相结合。

## 模板和泛型编程

### 了解隐式接口和编译期多态

Note:

- classes和templates都支持接口和多态。
- 对classes而言接口是显式，以函数签名为中心。多态则是通过virtual函数发生于运行期。
- 对Template参数而已，接口是隐式的，奠基于有效表达式。多态则是通过template具现化和函数重载解析发生于编译期。

### 了解typename的双重意义

Note:

- 声明template参数时，前缀class和typename可互换。
- 请使用关键typename标识从属类型名称；但不得在base class lists或member initialization list内以它作为base class 修饰符。

### 学习处理模板化基类内的名称

Note:

- 可在derived class 内通过『this->』指涉base class template内的成员名称，或藉由一个明白写出的『base class资格修饰符』完成

### 将与参数无关的代码抽离templates

Note：

- Template生成多个classes和多个函数，所以任何Template代码都不该于某个造成膨胀的template参数产生相依关系。
- 因非类型模板参数而造成的代码膨胀，往往可消除，做法是以函数类型或class成员变量替换Template参数。
- 因类型参数而造成的代码膨胀，往往可降低，做法是让带有完全相同二进制表述的具现类型共享实现码。

### 运用成员函数模板接受所有兼容类型

Note:

- 请使用member function template生成『可接受所有兼容类型』的函数。
- 如果你声明member template用于『泛化copy构造』或『泛化assignment操作』，你还是需要声明正常的copy构造函数和copy assignment操作符。

### 需要类型转换时轻微模板定义非成员函数

Note: 当我们编写一个class template，而它所提供之『与此template相关的』函数支持『所有参数之隐式类型转换』时，请将那些函数定义为『class template内部的friend函数』。

### 请使用traits classes表现类型信息

Note：

- Traits classes 使得『类型相关信息』在编译期可用。它们以template和『templates特化』完成实现。
- 整合重载技术后，traits classes有可能在编译期对类型执行if...else测试


### 认识template元编程

Note:

- TMP可将工作由运行期移往编译期，因而得以实现早期错误勘测和更高的执行效率。
- TMP被用来生成『基于政策选择组合』的客户定制代码，也可用来避免生成对某些特殊类型并不合适的代码。


## 定制new和delete

### 了解new-handler的行为

一个设计良好的new-handler必须做以下事情：

- 让更多内存可被使用
- 安装另一个new-handler
- 卸除new-handler
- 抛出bad_alloc的异常
- 不放回

Note:

- set_new_handler允许客户指定一个函数，在内存分配无法获得满足时调用。
- Nothrow new是一个颇为局限的工具，因为它只适用于内存分配；后续的构造函数调用还是可能抛出异常。

### 了解new和delete的合理替换时机

Note: 有许多理由需要写个自定的new和delete，包括改善效能、对heap运用错误进行调试、收集heap使用信息。

### 编写new和delete时需固守常规

Note:

- operator new 应当内含一个无穷循环，并在其中尝试分配内存，如果它无法满足内存需求，就应该调用new-handler。它应该拥有能力处理0byte申请。Class专属版本则还应该处理『比正确大小更大的错误申请』。
- operator delete应在收到null指针时不做任何事。Class专属版本则还应该处理『比正确大小更大的错误申请』。

### 写了placement new 也要写placement delete

Note:

- 当你写一个placement operator new，请确定也写了对应的placement operator delete。如果没有那么做，你的程序可能会发生隐微而时断时续的内存泄露。
- 当你声明placement new和placement delete，请确定不要无意识(非故意)地掩盖他们的正常版本。

## 杂项讨论

Note:

- 严肃对待编译器发出的错误信息。努力在你的编译器的最高警告级别下争取『无任何警告』的荣誉。
- 不要过度依赖编译器的报警功能，因为不同的编译器对待事情的态度并不相同。一旦移植到另一个编译器上，你原本依赖的警告信息有可能消失。

### 让自己熟悉包括TR1(C++11)在内的标准程序库

Note:

- C++ 标准程序库的主要机能由STL、iostreams、locales组成。并包含C99标准程序库。
- TR1添加了智能指针、一般化函数指针、hash-based容器、正则表达式以及另外10个组件的支持。
- TR1自身只是一份规范。为获得TR1的提供的好处，你需要一份实物。一个好的实物来源是Boost。

### 让自己熟悉Boost

Note：

- Boost是一个社群，也是一个网站。致力于免费、开源、同僚复审的C++程序库开发。Boost在C++标准化过程中扮演了深具影响力的角色。
- Boost提供许多TR1组件实现品，以及其他许多程序库。


# 后记

毫无疑问，这本书确实质量极高。作者最近才退休。不得不惊叹其C++的功底。C++就像是一个能力超强的野兽，程序员是否有能力驾驭它取决于自己。未来我还会在此方面学习，不过只会是兴趣或者偶尔用用。我特别对Modern C++感兴趣。那么，对C++有兴趣的同行们，一起加油吧。