#lang racket
(define (even n)
  (= 0 (remainder n 2)))

(define (square n)
  (* n n))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

(define (fast-prime n times)
  (define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime n (- times 1)))
        (else false)))

(define (prime? num)
  (fast-prime num 50))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (enumerate-interval begin last)
  (define (iter left right ans)
    (if (> left right)
        ans
        (iter (+ left 1) right (append ans (list left)))))
  (iter begin last null))

(define (flatmap proc seq)
  (accumulate append null (map proc seq)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (let ((val1 (car pair))
        (val2 (cdr pair)))
    (list val1 val2 (+ val1 val2))))

(define (prime-sum-pairs n)
  (filter prime-sum?
            (flatmap (lambda (i)
                   (map (lambda (j) (list i j))
                          (enumerate-interval 1 (- i 1))))
                   (enumerate-interval 1 n))))

(prime-sum-pairs 10)

(define (permutations s)
  (if (null? s)
      (list null)
      (flatmap (lambda (x)
                 (map (lambda (p) (cons x p))
                      (permutations (remove x s))))
      s)))

(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
          sequence))

(define (unique-pair n)
  (flatmap (lambda (i)
             (map (lambda (j)
                    (list i j))
                  (enumerate-interval 1 (- i 1))))
           (enumerate-interval 1 n)))

(define (three-pair-sum-eq-n n)
  (filter
   (lambda (tuple)
            (let ((val1 (car tuple))
                  (val2 (cadr tuple))
                  (val3 (caddr tuple)))
              (and (> val1 val2)
                   (> val2 val3))))
          (map (lambda (unique-pr)
                 (append unique-pr
                         (list(- n (car unique-pr) (cadr unique-pr)))))
               (unique-pair n))))

(unique-pair 6)

(three-pair-sum-eq-n 6)


(define (ts n)
  (map (lambda (i)
         (map (lambda (j)
               (list j i))
         (enumerate-interval 1 (- i 1))))
       (enumerate-interval 1 n)))

(three-pair-sum-eq-n 6)

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

(length (queens 8))

(define a '(1,2,3))
(define b '(4,5,6))
(car '(a,b))

(define (memq item x)
  (cond ((null? x) #f)
        ((eq? (car x) item) x)
        (else (memq item (cdr x)))))

(memq 'red '(red (shoes blue socks)))

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

(deriv '(+ x 3) 'x)

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

(define (mid-index x)
  (if (even x)
      (/ x 2)
      (/ (+ 1 x) 2)))

(define (nth-element elements index)
  (define (iter elts current)
    (if (= 1 current)
        (car elts)
        (iter (cdr elts) (- current 1))))
  (iter elements index))

(define (lower-elements elements index)
  (define (iter elts current result)
    (if (= 1 current)
        result
        (iter (cdr elts) (- current 1) (append result (list (car elts))))))
  (iter elements index '()))


(define (higher-elements elements index)
  (define (iter elts current)
    (if (= 1 current)
      (cdr elts)
      (iter (cdr elts) (- current 1))))
  (iter elements index))


(define (list->tree elements length)
  (if (< length 1)
    '()
    (let ((mid (mid-index length)))
      (let ((mid-element (nth-element elements mid))
            (left (lower-elements elements mid))
            (right (higher-elements elements mid)))
        (make-tree mid-element
                   (list->tree left (- mid 1))
                   (list->tree right (- length mid)))))))


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

