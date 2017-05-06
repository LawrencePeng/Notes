title: 《Java Puzzlers》读书笔记
tag: [Java , 读书 , 笔记 , 代码]
category: 读书
------

# 前言
《Java Puzzler》的作者之一Joshua Bloch也是《Effective Java》的作者。这本书将会告知你一些The suck part of Java。。。这本书并不好找，我是在我校的图书馆找到的。。。

书以谜题与解惑的方式解释了关于Java的95个程序的有趣的背后的故事。不得不说有一些谜题确实让人感觉好像是故意为之的。我对这本书给出3颗星的评价。下面我挑选书中9个Puzzlers，希望你和我一起探索它们。


# 谜题

## 谜题4：初级问题

下面程序将会打印出什么呢？

```java
public class Elementary {
	public static void main(String[] args) {
	System.out.println(12345+5432l);
	}
}
```
实际上，它会打印出17777。因为那不是54321，而是5432l。英文字母中1和l特别难很清楚，所以很多英文字体，特别是为编程优化的字体，都会特别区分这两个字符。

## 谜题14：转译字符的溃败
下面的程序会打印什么？
```
public class EscapeRout {
	public static void main(String[] args) {
	System.out.println("a\u0022.length()
						+\u0022b".length());
	}
}
```
你可能认为代码会打印出16。。。实际上这些\u0022不会被特殊处理，导致他们直接被理解为双引号，最后直接输出了"a".length() + "b".length() == 2；


## 谜题30： 循环者的爱子

提供一个对i的声明，将下面的循环抓变为一个无限循环。

```
while (i != i + 0) {
}
```

答案是任何的字符串都可以。。。


## 谜题36：优柔寡断

下面的程序究竟会返回什么呢？

```
public boolean decision() {
	try {
		return true;
	} finally {
		return false;
	}
}
```

答案是false。在一个try-finally语句中，finally语句块总是在控制权离开try语句块时执行。


## 谜题46：令人混淆的构造器实例

```
public class Confusing {
	private Confusing(Object o) {
		System.out.println("Object");
	}
	
	private Confusing(double[] dArray) {
		System.out.println("double array");
	}
	
	public static void main(String[] args) {
		new Confusing(null);
	}
}
```

会输出什么呢？

答案是调用double[]版本的重载。。。

因为JLS规定，调用重载时，编译器会决定调用最特化的版本。因为每个double[]都一定是Object，所以，会调用更特化的double[]版本。


## 谜题61：日期游戏

```
import java.util.*;

public class DatingGame {
	public static void main(String[] args) {
		Calendar cal = Calendar.getInstance();
		cal.set(1999,12,31);//Year,Month,Day
		System.out.print(cal.get(Calendar.Year) + " ");
		
		Date d = cal.getTime();
		System.out.println(d.getDay());
	}
}

```

你认为会打印1999 21么？

如果是，Too Young。它会打印2000 1。原因是，Calendar类将0表示1月。。。


## 谜题67：对字符串上瘾

```
pubic class StrungOut {
	public static void main(String[] args) {
		String s = new String("Hello world");
		System.out.println(s);
	}
}

class String {
	private final java.lang.String s;
	
	public String(java.lang.String s) {
		this.s = s;
	}
	public java.lang.String toString() {
		return s;
	}
}
```

上面的程序会如何？

答案是编译错误，原因是String类被包内代理类覆盖了。。。

## 谜题79：狗狗的幸福生活

```
public class Pet {
	public final String name;
	public final String food;
	public final String sound;
	
	public Pet(String name, String food, String sound) {
		this.name = name;
		this.food = food;
		this.sound = sound;
	}
	
	public void eat() {
		System.out.println(name + ": Mmmmm, " + food );
	}
	
	public void play() {
		System.out.println(name + ": " + sound + " " + sound);
	}
	
	public void sleep() {
		System.out.println(name + ": Zzzzzz...");
	}
	
	public void live() {
		new Thread() {
			public void run() {
				while(true) {
					eat();
					play();
					sleep();
				}
			}
		}.start();
	}
	
	public static void main(String[] args) {
		new Pet("Fido", "beef", "Woof").live();
	}
}
```

上面的程序运行结果是？

答案是无法编译成功，因为sleep函数和Object.sleep()发生了重名。

## 谜题81：无法识别的字符化
```
public class Greeter {
	public static void main(String[] args) {
		String greeting = "Hallo World";
		for(int i = 0; i < greeting.length(); i++)
			System.out.write(greeting.charAt(i));
	}
}
```

会输出hallo world么？

答案是不会，write函数不会刷新缓存。。。它是唯一不会自动刷新缓存的方法。

# 后记

《Java Puzzler》非常幽默，易于阅读。

阅读这本书能提高你对Java的Dark Part有更深的了解。