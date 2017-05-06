title: 《SICP》读书笔记和例题精解「1」
tag: [SICP, 笔记, 读书, 习题, 答案]
category: [读书]

------

# What is 《SICP》?

《SICP》,即Structure and Interpretation of Computer Programs(计算机程序的构造与解释)。《SICP》是MIT早期的CS001课程的教材。其享誉颇多，深受喜爱，被认为是CS领域的圣经。总之是一本超好的书。我在阅读完《SICP》的前3章后，深受其理念影响。于是想分享给大家这本书。关于《SICP》的地位，可以看[这篇文章](http://www.tuicool.com/articles/zQfueuj).

# 《SICP》in a few words

《SICP》授之于渔。它想告诉你如果你想要做一个大型的稳定的系统，你应该怎么控制你的复杂度。其实无非几种方法:
	
- 黑箱模型
- 约定接口
- 模块化(对象、流)
- 语言抽象

第一章通篇一个主旨就是为了告诉你如何用函数来造黑箱，隐藏细节。

下面就是笔记部分内容。

# 笔记

## 程序设计的基本元素

语言是工具。每个足够强大的语言为了方便你的编码，都提供了3种机制：

1. 基本表达形式
2. 组合的方法
3. 抽象的方法

然后简介了本书教学语言scheme。这部分希望读者自行了解。

表达式求值过程就是其语义的实现。

代换模型就是其中一种可能的实现方式。

然而由于很多缺点(比如性能问题)，Scheme本身不是使用这种模式求值的。

但代换模型能帮助你理解过程是怎样工作的。

使用函数做为黑箱来隐藏细节。

这一部分使用牛顿迭代法进行讲解。

## 过程与它们所产生的计算

我们可以利用代换模型理解过程指导的计算过程是具有「形状」的。它的行为本身可能需要状态的变换、保存等等。

书中简介了三种常见的计算过程：

1. 线性递归
2. 线性迭代
3. 树形递归

时间复杂度可以用代换模型下代换的次数与相关因子的关系说明。

空间复杂度可以用函数的参数量与相关因子的关系说明。

## 高阶函数做抽象

我们希望去通过解耦关系来实现组件分离、复用。从这个角度上，高阶函数能够帮助我们去分离出函数逻辑中本可以被重用的部分、提高我们的抽象水平。

作为编程者，应该对抽象的可能性保持敏感，设法识别出函数的基本抽象再进一步构造它们。高阶函数的重要性就在于使我们能在语言层去构造这些抽象。

第一级元素:

- 可以用变量命名
- 可以提供给过程作为参数
- 可以由过程作为结果返回
- 可以包含在数据结构中

本节使用了牛顿法、不定点作为例子。

# 章节例子解析

## 牛顿迭代法实现开平方函数

很多人对这个问题没有头绪，就会想着去暴力破解。实际上，这种方式当然能解决问题。

```
(define (sqrt x)
  (define toler 0.001)
  (define interval 0.001)
  (define (sqrt-iter begin)
    (if (< (abs (- (* begin begin) x)) toler)
           begin
           (sqrt-iter (+ begin interval))))
  (sqrt-iter 1))
(sqrt 2)
```

然而穷举法自然性能低下，所以，使用我们考虑优化其性能，一个常用的方法是使用牛顿迭代法。牛顿迭代法首先猜测一个数p所求的根，如果这个猜测不够好，就换为p + x/p再测试，如此迭代只到达到可以接受的情况。说完大家基本都知道怎么解了。贴代码。

```
(define (sqrt num)
  (define (sqrt-iter guess)
    (define (good_enough x)
      (< (abs(- (* x x) num)) 0.00001))
    (define (improve x)
      (/ (+ x (/ num x)) 2))
    (if (good_enough guess)
        guess
        (sqrt-iter (improve guess))))
```

## 找零钱

给了半美元，四分之一美元，10美分，5美分，1美分的硬币，将a美元换成零钱，一共有多少种换法？

将这个问题，可以规约为下面两个子问题：

换法 = 将现金a换成除第一种硬币以外的其他硬币的不同方式 + 将现金a－d换成所有种类硬币的不同方式。其中d为第一种硬币的面值。

考虑终止条件:

a=0时，说明已经成功将现金换完，算是一种有效换法。

a<0时，说明当前的现金比要兑换硬币面值小，不是有效换法。

n=0时，说明当前的现金无法兑换硬币了，不是有效换法。

了解了这些后，我们可以写代码了。

```
(define (count-change amount)
  (cc amount 5))
(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount
                     (- kinds-of-coins 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins)))))
(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))
```

递归空间上的要求太高了。所以我们改成迭代优化下。

```
 (define (count-change-iter amount)
    (cc-fifties amount 0))

 (define (cc-fifties amount acc)
    (cond ((= amount 0) (+ 1 acc))
     ((< amount 0) acc)
     (else (cc-fifties (- amount 50)
                (cc-quarters amount acc)))))

 (define (cc-quarters amount acc)
    (cond ((= amount 0) (+ 1 acc))
     ((< amount 0) acc)
     (else (cc-quarters (- amount 25)
             (cc-dimes amount acc)))))

 (define (cc-dimes amount acc)
    (cond ((= amount 0) (+ 1 acc))
     ((< amount 0) acc)
     (else (cc-dimes (- amount 10)
             (cc-nickels amount acc)))))

 (define (cc-nickels amount acc)
    (cond ((= amount 0) (+ 1 acc))
     ((< amount 0) acc)
     (else (cc-nickels (- amount 5)
                (cc-pennies amount acc)))))

 (define (cc-pennies amount acc)
    (cond ((= amount 0) (+ 1 acc))
     ((< amount 0) acc)
     (else (cc-pennies (- amount 1)
                (cc-nothing amount acc)))))

 (define (cc-nothing amount acc)
    acc)
```

这样空间复杂度降低到了O(1)了。
 
 
## O(logn)的求幂

一般很快就能想到O(n)时间复杂度的power(x, exp)函数的实现。

```
(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))
```

然而运用(x^2)^p = (x^p)^2的性质，我们很快也可以实现降低时间复杂度到O(logn)。

```
(define (exp x n)
  (define (even n)
    (= (remainder n 2) 0))
  (define (exp-iter a b n)
    (cond ((= n 0) a)
          ((even n) (exp-iter a (* b b) (/ n 2)))
          (else (exp-iter (* a b) b (- n 1)))))
  (exp3-iter 1 x n))
```

## 素数判定

很容易想到迭代判定素数的算法。时间复杂度为0(n^1/2)


```
(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))

We can test whether a number is prime as follows: n is prime if and only if n is its own smallest divisor.

(define (prime? n)
  (= n (smallest-divisor n)))
```

然而通过费马小定理，我们却能够实现一个O(logn)的素数判定程序。

费马小定理：**如果n是一个素数，a是<n的任意正整数，那么a^n与a mod n同余。**

```
(define (fast-prime n times)
  (define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime n (- times 1)))
        (else false)))
```

如果任取x个a都满足这一性质，我们就有1-1/2^x的概率认为其为真。因此我们可以根据所需要的不确定度来决定x的数量。

## 折半法求方程的根

通过折半法的例子，我们能感受到高阶函数在处理抽象问题时的方便。

```
(define (search f neg-point pos-point)
  (define (close-enough? neg pos)
    (< .0001 (abs (- pos neg))))
  (let ((middle-point (/ (+ neg-point pos-point) 2)))
    (if (close-enough? neg-point pos-point)
        middle-point
        (let ((test-val (f middle-point)))
          (cond ((positive? test-val)
                 (search f neg-point middle-point))
                ((negative? test-val)
                 (search f middle-point pos-point))
                (else middle-point))))))

(define (half-interval-method f a-point b-point)
  (let ((a-val (f a-point))
        (b-val (f b-point)))
    (cond ((and (negative? a-val) (positive? b-val))
           (search a-point b-point))
          ((and (negative? b-val) (positive? a-val))
           (search b-point a-point))
          (else
           (error "vals are not of opposite sign" a-point b-point)))))
```

## 不动点

不动点即是使f(x)  = x的点。可以调用f(x)的值再调用，如此直至出现两次调用的值差距小于容忍度终止寻得不动点。这样就码码嘛。

```
(define (fixed-point f first-guess)
  (define tolerance .0001)
  (define (close-enough? val nextval)
    (< tolerance (abs ( - (val nextval)))))
  (define (try guess)
    (let ((nextval (f guess)))
      (if (close-enough? guess nextval)
          nextval
          (try nextval)))))
```

## 牛顿法

牛顿法告诉我们如果g(x)是一个可微方程，那么方程g(x) = 0的一个解就是f(x) = x - g(x)/g'(x)的一个不动点。

我们可以用刚才造出来的不动点的过程来快速收敛得到g(x)=0的解了。

不过首先我们要有g'(x)的函数。

```
(define (deriv g)
  (define dx .0001)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))
```

有了它我们要有f(x)的定义。

```
(define (newton-transform g)
  (lambda (x)
    (-(x (/ g x) ((deriv g) x)))))
```

现在利用f(x)求不定点吧。

```
(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))
```

不过我们发现f(x)的实现可以被重用。所以不如改写成参数传入。

```
(define (fixed-point-transfrom g transform guess)
  (fixedpoint (transform g) guess))
```

这样我们只要传入适当的参数，就能求出任意g(x)的解了。

# 精选题解析

1.5 Ben Bitdiddle 发明了一种检查方法，能够确定解释器究竟采用哪种序求值，是采用应用序，还是正则序。代码如下:

```	
(define (p) (p))
(define (test x y)
	(if (= x 0))
	0
	y))
(test 0 (p))
```

如果使用应用序，那么会先对参数求值再应用，不难想象其会陷入无限次的求值中。

如果使用正则序，那么机会先展开在归约，可以想见由于传入的第一个参数为0，在展开中并不会有p出现，就会正常返回0。本题主要考察对正则序和应用序的理解。实际上可以把正则序想成懒式的，而应用序则是常见的pass-by-value的。

1.7 原先的牛顿迭代法的实现对于特大和特小的数表现都不好。原因在于good-enough实现的时候是使用一次结果进行误差判断的原因，你能不能实现一个判断两次迭代相差值来判定good-enough的版本呢？

实现比较简单，直接贴代码:

```
(define (good-enough? old-guess new-guess)
    (> 0.01
       (/ (abs (- new-guess old-guess))
          old-guess)))
```
```
(define (sqrt-iter old-guess x)
    (let ((new-guess (improve old-guess x)))
        (if (good-enough? old-guess new-guess)
            new-guess
            (sqrt-iter new-guess x))))
```

1.11 求出杨辉三角的第(row,col)个。

根据定义我们很快就能写出递归实现。

```
(define (pascal row col)
	(if ((or (= col 0) (= row col))
            1
          (else (+ (pascal (- row 1) (- col 1))
                   (pascal (- row 1) col))))
```
然而由于是树形递归，它的效率非常低下。

这里如果我们用yanghui(row,col) = row! / col! * (row - col)的性质。

就能在线性时间内完成。

首先实现n!

```
(define (factorial n)
    (fact-iter 1 1 n))

(define (fact-iter product counter max-count)
    (if (> counter max-count)
        product
        (fact-iter (* counter product)
                   (+ counter 1)
                   max-count)))
```

然后就顺理成章了。

```
(define (pascal row col)
    (/ (factorial row)
       (* (factorial col)
          (factorial (- row col)))))
```

1.19 log(n)时间复杂度的第n个斐波那契数实现

非常经典的题目，使用矩阵运算来降低时间复杂度。

实现的原理就是多次矩阵变换下的p,q值的规律。

大家可以自己去实现一遍。

```
(define (fib n)
    (fib-iter 1 0 0 1 n))

(define (fib-iter a b p q n)
    (cond ((= n 0)
            b)
          ((even? n)
            (fib-iter a 
                      b
                      (+ (square p) (square q))     ; 计算 p'
                      (+ (* 2 p q) (square q))      ; 计算 q'
                      (/ n 2)))
          (else
            (fib-iter (+ (* b q) (* a q) (* a p))
                      (+ (* b p) (* a q))
                      p
                      q
                      (- n 1)))))
```

1.28 Miller-Rabin检查

有一些数能够骗过费马检查过程。然而有一种Miller-Rabin检查能防骗，请实现Miller-Rabin检查。

```
(define (even? n)
  (= (remainder n 2) 0))

(define (trivial-square-test a n )
  (if (and (not (= a 1)) 
  		(not (= a (- n 1))) 
  		(= (remainder (square a) n) 1))
  	0
 	a))

(define (expmod b e m)
	(cond ((= e 0) 1)
		((even? e) (remainder (square (trivial-square-test (expmod (square b) (/ e 2) m) m)) 
m))
		(else (remainder (* b (expmod b (- e 1) m)) 
		m))))
```
1.46 

题目要求我们给出这样一个 iterative-improve 函数：它接受一个用于检测猜测值是否足够好的函数(close-enough?)，以及一个用于改进猜测值的函数(improve)，并返回一个接受单个初始猜测值(first-guess)的过程，这个过程可以一直改进猜测值，直到猜测足够好。

我们留意我们写过的不动点的函数。

```
(define (fixed-point f first-guess)
  (define tolerance .0001)
  (define (close-enough? val nextval)
    (< tolerance (abs ( - (val nextval)))))
  (define (try guess)
    (let ((nextval (f guess)))
      (if (close-enough? guess nextval)
          nextval
          (try nextval)))))

```

其实这个函数和我们要的iterative-improve已经很像了。

我们首先将close-enough?提取出来

```
(define (fixed-point f first-guess close-enough?)
  (define (try guess)
    (let ((nextval (f guess)))
      (if (close-enough? guess nextval)
          nextval
          (try nextval)))))
```

实际上我们的improve这里好像就是(f guess)，所以我们抽取掉。

```
(define (fixed-point first-guess close-enough? improve)
  (define (try guess)
    (let ((nextval (improve guess)))
      (if (close-enough? guess nextval)
          nextval
          (try nextval)))))
```

至于first-guess，写进函数就行了。

```
(define (fixed-point close-enough? improve)
  (define tolerance .0001)
  (define (try guess)
    (let ((nextval (improve guess)))
      (if (close-enough? guess nextval)
          nextval
          (try nextval))))
  try first-guess)

```

最后 改下名，收工。

```
(define (iterative-improve close-enough? improve)
  (define (try guess)
    (let ((nextval (improve guess)))
      (if (close-enough? guess nextval)
          nextval
          (try nextval))))
  try first-guess)
```
