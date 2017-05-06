title: 《Effective Modern C++》「1」读书笔记
tag: [C++, Effective, 读书, 笔记, 编程]
category: 编程
------


# 前言

前段时间总是心不在焉的。不过现在还好，感觉回到正常状态了。

以后只要是读书笔记系列呢，第一篇都会上传自拍。。。(这是什么嗜好啊。。。)。当然主角是书啦。

本次阅读的书籍还是大名鼎鼎的Effective系列丛书——《Effective Modern C++》。

![](http://www.llpeng.com:8082/EMCPP.jpg)

这次购买的是英文影印版。以我的英文水平是能看得懂的，但是速度会比中文版看的慢些。不过其实中文翻译一直是一个很坑的东西。比如大名鼎鼎的龙书第二版的中翻简直就是。。。

本书将会介绍Modern C++的一些知识。我们普通大学教学只会讲C with Class。。。

本文读者Dependency： 熟悉C++11新特性

# 正文

## 类型推导

### 理解模板类型推导

有些人会说C++11才让C++有类型推导功能。这简直就是误人子弟。C++98就有了模板类型推导，这不就是类型推导？

```
template<typename T>
void f(ParamType param);
```

例如上面的模板。

我们可能会这么调用`f(expr)`

ParamType有可能有三种情况。

- ParamType是一个指针或引用类型。但不是universal 引用.
- ParamType是一个universal 引用。
- ParamType既不是指针也不是引用。

我们分别对这三种情况进行讨论。

#### ParamType是一个指针或者引用，但不是universal 引用

这种情况下，推导遵循如下规则：

- 如果expr的类型是一个引用，忽略引用部分。
- 将expr的类型和ParamType进行匹配来决定T。

我们举例子说明：

```
template<typename T>
void f(T& param);

int x = 27;
const int cx = x;
const int& rx = x;

f(x); // T is int, param's type is int&

f(cx); //T is const int, param's type is const int &

f(rx); //T is const int, param's type is const int &

```

如果我们的的ParamType中不仅声明了引用性，还声明了常量性，也是遵行上面的规则。

同样的规则也适用于指针类型。

#### ParamType是一个通用universal 引用

那么会遵循以下规则：

- 如果expr是左值，T和ParamType都会被推断为左值引用。
- 如果expr是右值，按照第一中情况处理。

我们同样举个例子说明：

```
template<typename T>
void f(T&& param);

int x = 27;
const int cx = x;
const int& rx = x;

f(x) //x is lvalue, so T is int&, param's type is also int&.

f(cx) // x is lvalue, so T is const int&, param's type is also const int &

f(rx); //rx is lvalue, so T is const int&, param's type is also const int &

f(27) // 27 is rvalue, so T is int, param's type is also const int && 
```

#### ParamType既不是指针也不是引用

这种情况下规则如下：

- 和以前一样，如果expr的类型为引用，忽略引用部分。
- 忽略引用后，如果有指明const、volatile，同样忽略。


我们还是用例子说明一切吧：

```
template<typename T>
void f(T param)

int x = 27;
const cx = x;
const rx = x;

f(x); //T's param and param's type are both int

f(cx);//T's param and param's type are both int

f(rx);// T's param and param's type are both int
```
可以想见，这种情况下，一定发生的是pass-by-value。


我们再考虑些特殊情况。

#### 数组参数

实际上，传统的数组在做为参数时，经常会退化为指针。

也就是说`void myFunc(int param[])`和`void myFunc(int* param)`是等价的。



然而故事还没完：

尽管函数不能声明参数为真实的数组，但是他们能声明参数为真实数组的引用。

所以如果我们这么做：

```
template<typename T>
void f(T& param);
```
如此，当我们传一个数组进去，它并没有退化为指针。

T会被推断为Type (&) [N]。世界又美好了。

举个例子：我们可以这么写arraySize函数：

```
template<typename T, std::size_t N>
constexpr std::size_t arraySize(T (&) [N]) noexcept
{
	return N;
}
```

该函数能无错的返回一个数组的大小。

至于这个constexpr和noexcept是什么，我以后再说。

#### 函数参数

同样的规则一样发生于函数：对于传函数，传的是函数指针。对于传函数引用，同样不退化。

### 理解auto类型推导

如果你了解了模板类型推导的规则，你几乎已经了解了所有auto类型推导的规则了。

例如

```
auto x = 27;

const auto cx = x;

const auto& rx = x;
```

如果看完了上面的内容，你应该清楚上面三行代码在干嘛。

如果没学好，请仔细推敲上面的事项。

那么auto类型推导和模板类型推导有什么不同呢？

我们先说明，在C++11中有四种初始化语句是合法的：

```
auto x1 = 27;
auto x2(27);
auto x3 = { 27 };
auto x4{27};
```

这四句话都能编译，不过意义不同。

实际上当你使用统一初始化语句 -- 花括号语句时其实是创建了一个特化的std::initializer_list。所以下面2行推导类型为std::initializer_list<int>。这明显不是你要的。

例如:

```
auto x = {11, 23, 9};

template<typename T>
void f(T param);

f({11, 23, 9}); //error!!! 不能推断类型。
```

我们应该修改我们的模板声明为：`void f(std::initializer_list<T>)`

这便是auto类型推导规则和模板推导规则的唯一区别。

然而故事还没完，C++14中，允许auto来声明一个函数的返回值应该被推导，允许lambda使用auto作为类型声明。然而，这些auto却会使用模板类型推导规则。所以以下代码无法编译：


```
auto createInitList()
{
	return { 1, 2, 3 };// error!!! can't deduce type for { 1, 2, 3 }
}
```

```
std::vector<int> v;

...

auto reset = [&v](const auto& newValue) {v = newValue;}

...

resetV({1, 2, 3}) // error!!! can't deduce type for { 1, 2, 3 }
```

### 理解decltype

decltype -- 给一个名字或者表达式，返回其类型。

例如

```
const int i = 0; //decltype(i) == int
```

或许decltype的主要用途是声明函数模板的返回值，当返回值依赖于参数类型时。

例如

```
template<typename Container, typename Index>
auto  autoAndAccess(Conntainer& c, Index i)
	-> decltype(c[i])
{
	authenticateUser();
	return c[i];
}
```

auto这里用来说明这里的返回值类型需要推导。

decltype重定义其类型为c[i]的类型。

在C++14中有一个语法糖可以简化这个代码：

```
template<typename Conntainer, typename Index>
auto authAndAccess(Container&c, Index i)
{
	authenticateUser();
	return c[i];
}
```

不过其实它并不能很精确的工作。

如果[]运算符返回的是T&类型，那么下面的代码将无法运行。

```
std::deque<int> d;

...
authAndAccess(d, 5) = 10;// this won't compile
```

所以我们需要用到decltype：


```
template<typename Conntainer, typename Index>
decltype(auto) authAndAccess(Container&c, Index i)
{
	authenticateUser();
	return c[i];
}

```

如此便是C++14的90%正确代码。如何才是100%呢?后面再说。

decltype和auto相得益彰。

```
Widget w;

const Widget& cw = w;

auto myWidget1 = cw; // auto type deduction:
				     // myWidget1's type is Widget

decltype(auto) myWidget2 = cw; //decltype type deduction:
							   //myWidget2's type is const Widget&

```

需要求出,(x)会一个左值引用。

所以会出现以下情况：

```
decltype(auto) f1()
{
	int x = 0;
	...
	return x; // decltype(x) is int.
}

decltype(auto) f1()
{
	int x = 0;
	...
	return (x);// decltype((x)) is int&.
}
```

### 如何查看推导类型

无非几种方法：

- 靠IDE的类型推导
- 编译器的分析信息
- 运行时输出 typeid 和 type_info::name
- boost::type_index

这就是你有所有的方式了。

## auto

### auto好于显式类型声明

auto好于显式类型声明有几点：

1. auto可以避免不必要的类型定以后不使用的情况。
2. 简化你的代码，让你的代码更加清晰。
3. 避免一些类型定义引起的错误。
4. 一些额外好处。

我这里主要讲下第四点：

考虑std::function。这是一个C++标准库中出现的用来推广函数指针概念的模板类。其能够用来指代所有的可调用对象。

你必须定义函数的类型来创建你的std::function对象。
例如：

```
std::function<bool(const std::unique_ptr<Widget>&,
	const std::unique_ptr<Widget>&)> func;
```

因为lambda能生成一个可调用对象，所以它能被std::function对象存储。

```
std::function<bool>(const std::unique_ptr<Widget>&,
		const std::unique_ptr<Widget>&)>
		derefUPLess = [](const std::unique_ptr<Widget>& p1,
		const std::unique_ptr<Widget>& p2)
		{ return *p1 < *p2; }
```

我们先不说这个代码中有多少类型信息的问题。考虑实际的性能吧：

std::function要比闭包本身耗费更多的空间，因为它还要去存储参数和返回值的信息。这可能会让它在堆上分配比闭包更多的空间。同时，inclining的限制和其他一些原因将会导致调用一个std::function一定比调用一个声明为auto的函数对象要更加耗时。所以在时空上，都不如auto直接声明。


### 当auto无法推导出期望的类型时使用显式类型初始化语法

auto似乎是个不错的东西。那么它是否总是用的很舒心呢？其实不一定。

考虑这个函数`std::vector<bool> feature(const Widget& w);`

随后我们执行以下代码：

```
Widget w;

...

auto highPriority = features(w)[5];

...

processWidget(w, highPriority);
```

好像没什么错误是吧。

其实这个代码的行为未定义。

为什么？

因为禁止vector返回bits的引用，所以vector的operator[]运算符返回类型为std::vector<bool>::reference类型的一个对象而不是bool。

则很有可能导致processWidget运行时判断失误。

面对这种由于代理类带来的类型MisMatch的情况。最简单也是最常见的方式就是退一步了：`auto highPriority = static_cast<bool>(features(w)[5]);`

使用C++风格的转型，让我们在C++11依然能够很优雅的处理这种edge case。代码并没有付出很多成本。

# 后记

这篇主要讲解了C++11的类型推导部分。

下一章会主要讲解C++11的智能指针和代码迁移部分。