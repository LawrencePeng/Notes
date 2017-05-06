#lang racket
(define (abs x)
  (if (< x 0)
      (- x)
      x))

(define (max x y z)
    (if (< z
           (if (< x y)
               y
               x))
        (if (< x y)
            y
            x)
        z))
(define (fact x)
  (if (= x 1)
      1
      (* (fact (- x 1)) x)))

(fact 4)

(define (fac n)
  (define (fac-iter product counter max-count)
    (if (> counter max-count)
        product
        (fac-iter (* counter product)
                  (+ counter 1)
                  max-count)))
  (fac-iter 1 1 n))
(define (sqrt num)
  (define (sqrt-iter guess)
    (define (good_enough x)
      (< (abs(- (* x x) num)) 0.00001))
    (define (improve x)
      (/ (+ x (/ num x)) 2))
    (if (good_enough guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1))
(sqrt 2)
(define (fib n)
  (if ((or (= n 1) (= n 0)))
      1
      ((+)(fib n - 1)(fib n))))
(define (fib2 n)
  (define (fib-iter a b count)
    (if (= count 0)
        b
        (fib-iter (+ a b) a (- count 1))))
  (fib-iter 1 0 n))
(fib2 5)
(define (foo n)
  (if (< n 3)
      n
      (+ (foo (- n 1)) (* 2 (foo (- n 2))) (* 3 (foo (- n 3))))))
