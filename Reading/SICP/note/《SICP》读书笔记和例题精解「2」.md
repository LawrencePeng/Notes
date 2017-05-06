title: 《SICP》读书笔记和例题精解「2」
tag: [SICP, 读书, 笔记, 精解]
category: 读书

------


# 第二章 in a nutshell

第二章主要关心数据抽象，也就是**如何构造和处理复杂数据对象**。

## 为什么要构造复杂数据对象？

构造复杂数据对象能够使我们:
	
1. 提高数据的抽象性，让使用者不必关系实现细节。
2. 提高设计模块化程度。
3. 减少代码耦合情况。
4. 通过制定接口，降低了模块间对接的复杂度。

同时也讲解了Scheme中的符号，这及其类似于引用的概念。讲解例子是求导程序。


## 如何制定接口？

一般的接口包括: 构造函数，选择函数(Selector)。

第二章中使用Lisp表作为一种通用的接口，讲解了如何构造和利用通用的接口来提高程序的话和抽象性。


## 数据导向的程序设计

通过数据导向的程序设计，我们能够使系统处于一个强可加性的状态。

书中主要讲解了Scheme的包的概念的设计和使用。

然后讲解了如何使用*put* 和*get*过程，来实现包安装，方法检索，过程局部抽取。

同时也提及了另一种叫做**消息传递**的方式。这种方式类似于对象。

# 笔记

## 层次性数据和闭包性质

Lisp中的闭包性质并不同于我们在类似于JS这种语言中提及的概念。JS中的闭包主要是指代Function in the Function。而这里的闭包，这是一种可以将组合的结果再组合的能力。如此，就能灵活的构造复杂的数据对象，或层次性结构。

使用约定的界面能够能构建出类似于流的运行过程，大大提高代码的清晰性和可读性。

将程序表示为一些针对序列的操作，这样做的价值就在于能够帮助我们得到模块化的程序设计。得到由一些比较独立的片段的组合构成的设计。通过提供一个标准组件的库，并使这些组件都有着一些能够以各种灵活方式互相连接的约定界面，将能进一步推动人们去做模块化的设计。

在工程设计中。模块化结构是控制复杂性的一种威力强大的策略。

用表实现的序列作为所用的统一标示结构，我们就能将程序对于数据结构的依赖性降低到为数不多的几个序列操作上。通过修改这些操作，就可以在序列的不同表示之间切换，并保持程序的整个设计不变。

一个复杂的系统应该通过一系列的层次构造出来，为了描述这些层次，需要使用一系列的语言。构造各个层次的方式，就是设法组合起作为这个层次中部件的各种基本元素，而构造出的部件又可以作为另一个层次的基本元素。在分层设计中，每个层次上所用的语言都提供了一些基本元素、组合手段、还有对该层次中的适当细节做抽象的手段。

分层设计有助于使程序更加强健。

## 抽象数据的多重表示

如果说抽象屏障让我们能够将数据的定义和操作隔离开，是一种竖直方向上的分层隔离的话。
模块化则能让我们获得水平分层隔离的能力。

Lisp中通过打类型标签的方式，能够让我们实现模块化。

认识数据抽象的一种方式是将其看做『最小允诺原则』的一种应用。

检查一个数据项的类型，并据此去调用适当的过程称为基于类型的分派。但是这种方式因为各种原因，并不具有可加性。

而*数据导向的程序设计*的编程技术提供了进一步模块化设计的能力。

数据导向的程序设计就是一种使程序能够直接利用类型和操作定义的二维表格工作的程序设计技术。

管理这二维表的形式既可以是按照类型进行分派的，也可以是按照操作进行分派的。而这种方式称为**消息传递**。

## 带有通用型操作的系统

一种类型转换操作就是定义好类型转换的过程，然后执行强制类型转换。

一种有效地实践就是类型系统的方式。

我们称为类型的层次结构。

这种方式类似于OOP中的继承和向上/下转型

然而层次结构的不足也很明显。

一个类型向上/下转型的方向可能有多个。（C++对象中的菱形继承问题）


下面我们用流的方式简介书中的一些实例。

# 章节例子解析

## 有理数运算

我们知道有理数都是能被表示成分数的数。那么如何才能够标示出分数呢？我们思考分数的组成。有分子与分母，只要一个分数的分子与分母是确定的。分数自然是确定。那么如何才能将它们绑定在一起呢？不同语言有不同的方式。有些语言提供了结构体/类这种概念。有些语言中可以通过函数绑定绑定。诸如此类。Lisp中我们可以使用系统定义的cons、car、cdr这一组函数实现这一绑定的生成、和两个被绑定对象的获取操作。

所以我们可以很快写出下面的代码。

```
(define (make-rat x y)
  (if (> (/ x y) 0)
      (cons (abs x) (abs y))
      (if (> y 0)
          (cons x y)
          (cons (- 0 x) (- 0 y)))))
          
(define (numer n)
    (/ (car n))

(define (denom n)
    (/ (cdr n)))
```
然后我们用它做了一些运算后就会发现，结果并没有进行通分。所以我们马上想到依靠最大公约数求出通分后的结果。于是代码就修改成下面这样。

```
(define (numer n)
  (let ((g (gcd (car n) (cdr n))))
    (/ (car n) g)))

(define (denom n)
  (let ((g (gcd (car n) (cdr n))))
    (/ (cdr n) g)))
```

实际中，究竟是在构造时通分还是在取值时通分取决于实际场景的需要进行选择。这也体现了数据抽象的好处，就是推迟我们做决策的时间，获得更多设计时的灵活性。

## 区间运算

区间大家都非常熟悉了。我们不难想到区间（假设都是闭区间）如果左右端点确定，那么其实也是确定的。

所以我们很快可以实现。

```
(define (make-interval a b) (cons a b))

(define (upper-bound x)
  (if (> (car x) (cdr x))
      (car x)
      (cdr x)))

(define (lower-bound x)
  (if (> (car x) (cdr x))
      (cdr x)
      (car x)))
```

同样，这里依然体现了数据抽象的推迟决定的好处。你依然可以选择在构造时就将区间端点进行约束，否则也可以像上面这也取值再去取。这里如果大量进行取值的话还是使用第一种方法好。

构造完数据后，我们构造数据的一些操作。这里我们通过区间加减法来讲解。

```
(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (sub-interval x y)
  (abs (- (- (upper-bound x) (lower-bound x))
          (- (upper-bound y) (lower-bound y)))))
```

这部分没什么好讲的，快过。

## List的通用操作

常用的操作有Length

```
(define (length items)
  (define (length-iter items now)
    (if (null? items)
        now
        (length-iter (cdr items) (+ now 1))))
  (length-iter items 0))
```
Append

```
(define (append-list list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))
```
Reverse

```
(define (reverse-list l)
  (if (null? l)
    null
    (append-list (reverse-list (cdr l)) (list (car l)))))
```

Map

```
(define (scala-list2 items factor)
  (map (lambda (item) (* factor item)) items))
```

ForEach

```
(for-each (lambda (x) (newline)(display x)) squares)
```

Filter

```
(define (filter predict sequance)
  (cond ((null? sequance) null)
        ((predict (car sequance))
         (cons (car sequance)
               (filter predict (cdr sequance))))
        (else (filter predict (cdr sequance)))))
```

Accumulate/Fold Right
```
(define (accumulate op initial sequance)
  (if (null? sequance)
      initial
      (op (car sequance)
          (accumulate op initial (cdr sequance)))))
```

Fold Left
```
(define (fold-left op initial sequance)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequance))
```

提供了一些实现/使用的方案。感兴趣的可以实现下对于树的版本。


## 嵌套映射

通过嵌套映射，我们能很方便地建立起序列的概念。

书中介绍的是产生何为素数的序列的例子

```
(define (prime-sum-pairs n)
  (filter prime-sum?
            (flatmap (lambda (i)
                   (map (lambda (j) (list i j))
                          (enumerate-interval 1 (- i 1))))
                   (enumerate-interval 1 n))))
```

## 符号求导

符号求导需要利用符号这个概念，其类似于引用。

先按照意愿写出代码的骨架


```
(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var)
             1
             0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
          (make-product (multiplier exp)
                        (deriv multiplicand exp) var)
          (make-product (deriv (multiplier exp) var)
                        (multiplicand exp))))
         (else
          (error "unknown expression type -- DERIV " exp))))
```

随后我们一个个完成它们。

```
(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2) (+ a1 a2)))
        (else (list '+ a1 a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))

(define (augend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))

(define (multiplicand p) (caddr p))
```

## 集合的表示

### 通过无序表

```
(define (element-of-set x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set x (cdr set)))))

(define (adjoin-set x set)
  (if (element-of-set x set)
      set
      (cons x set)))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set (car set1) set2)
        (cons (car set)
              (intersection-set (cdr set1) set2)))
        (else (intersection-set (cdr set1) set2))))

(define (union-set set1 set2)
  (cond
    ((null? set1) set2)
    ((element-of-set? (car set1) set2)
     (union-set (cdr set1) set2))
    (else
     (union-set (cdr set1) (cons (car set1) set2)))))
```

### 通过有序表

```
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (car set)) true)
        ((< x (car set)) false)
        (else (element-of-set? x (cdr set)))))

(define (intersection-set-sort set1 set2)
  (if (or (null? set1) (null? set2))
      '()
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1 (intersection-set-sort (cdr set1)
                                               (cdr set2))))
              ((< x1 x2)
               (intersection-set-sort (cdr set1) (set2)))

              ((> x1 x2)
               (intersection-set-sort set1 (cdr set2)))))))


(define (adjoin-set-sort a set)
  (cond
    ((null? set) (cons a set))
    ((= (car set) a) set)
    ((> (car set) a)
      (cons a set))
    (else 
      (cons (car set)
        (adjoin-set-sort a (cdr set))))))

(define (union-set-sort set1 set2)
  (cond
    ((null? set) set2)
    ((null? set2) set1)
    (else
     (let ((a1 (car set1))
           (a2 (car set2)))
       (cond
         ((> a1 a2) (cons a2 (union-set-sort set1 (cdr set2))))
         ((< a1 a2) (cons a1 (union-set-sort (cdr set1) set2)))
         (else (cons a1 (union-set-sort (cdr set1) (cdr set2)))))))))

```

### 通过排序树

```
(define (entry tree)
  (car tree))

(define (left-branch tree)
  (cadr tree))

(define (right-branch tree)
  (caddr tree))

(define (make-tree left right)
  (list entry left right))

(define (element-of-tree x tree)
  (cond ((null? tree) #f)
        ((= x (entry tree) #t))
        ((< x (entry tree))
         (element-of-tree x (left-branch set)))
        ((> x (entry tree))
         (element-of-tree x (right-branch set)))))

(define (adjoin-tree x tree)
  (cond ((null? set) (make-tree x '() '()))
        ((= x (entry tree)) tree)
        ((< x (entry tree))
         (make-tree (entry tree)
                    (adjoin-tree x (left-branch tree))
                    (right-branch tree)))
        ((> x (entry tree))
         (make-tree (entry tree)
                    (left-branch tree)
                    (adjoin-tree x (right-branch tree))))))

```

由于都是数据结构的基本知识点，不进行讲解。


## Huffman树

首先Huffman Tree的结构要素的实现。


```
(define (make-leaf symbol weight)
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf x) (cadr x))

(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))

(define (left-branch-tree tree) (car tree))

(define (right-branch-tree tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))
```
然后是编码的实现。

```
(define (adjoin-tr x tree)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-tr (x (cdr set)))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-tr (make-leaf (car pair)
                              (cadr pair))
                   (make-leaf-set (cdr pairs))))))

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (arrange tree leaf-sets)
  (cond
    ((null? leaf-sets) (list tree))
    (else 
      (let ((tw (weight tree))
            (lw (weight (car leaf-sets))))
        (if (< tw lw)
          (cons tree leaf-sets)
          (cons (car leaf-sets)
                (arrange tree (cdr leaf-sets))))))))

(define (successive-merge leaf-sets)
  (if (= 1 (length leaf-sets))
    (car leaf-sets)
    (successive-merge 
      (arrange (make-code-tree (car leaf-sets) (cadr leaf-sets))
               (cddr leaf-sets)))))
```

然后是解码的实现。


```
(define (decode bits tree)
  (define (decode-1 bits current-branch)
  (if (null? bits)
      '()
      (let ((next-branch (choose-branch (car bits) current-branch)))
        (if (leaf? next-branch)
            (cons (symbol-leaf next-branch)
                  (decode-1 (cdr bits) tree))
            (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (if (= bit 0)
      (left-branch branch)
      (right-branch branch)))
```

# 精选题解析

## Church 记数

丘奇是著名的lambda演算的发明人。在lambda公理系统中，一切都是函数。

0是这么表示的

```
(define zero
  (lambda (f)
    (lambda (x)
      x)))
```

加一操作是这么表示的

```
(define (add-1 n)
  (lambda (f)
    (lambda (x)
      (f ((n f) x)))))
```
请不用上门的函数直接定义1、2和+操作。

我们用归约模型替换掉(add-1 zero)得到如下代码。

```
(define one
  (lambda (f)
    (lambda (x)
      (f x))))
```

再替换一次得到2为

```
(define two
  (lambda (f)
    (lambda (x)
      (f (f x)))))
```
通过观察不难得出规律是嵌套的lambda内的f的调用次数决定你数值。

于是我们就能定义出+运算为

```
(define (add m n)
  (lambda (f)
    (lambda (x)
      ((m f) ((n f) x)))))
```

## 八皇后问题

八皇后问题要求在一个8*8的棋盘中每个其中不同行、列、对角线。是算法经典问题。

我们这里需要使用嵌套映射来应用序列的概念。

题中代码框架已经给出

```
(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-postion new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))
```
我们需要实现empty-board、adjoin-postion、safe?三个过程。

因为代码骨架已经写出了。所以题目没什么难度了。

```
(define empty-board '())

(define (adjoin-postion new-row k rest-of-queens)
  (append rest-of-queens (list new-row)))


    
(define (ok? v pos offset)
    (cond
      ((null? pos) #t)
      ((and (not (= v (car pos)))
             (not (= v (- (car pos) offset)))
             (not (= v (+ (car pos) offset))))
        (ok? v (cdr pos) (+ 1 offset)))
      (else #f)))

(define (safe? k positions)
  (let ((rev_positions (reverse positions)))
    (ok? (car rev_positions) (cdr rev_positions) 1)))

```

我们测试8皇后问题的可行情况

```
(length (queens 8)) == 92
```

说明代码正确。


