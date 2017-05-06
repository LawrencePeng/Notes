#lang racket
(define (exp x p)
  (define (exp-iter a b n)
    (cond ((= n 0) a)
      ((= 0 (remainder n 2)) (exp-iter a  (* b b) (/ n 2)))
      (else (exp-iter (* a b) b (- n 1)))))
  (exp-iter 1 x p))

(exp 2 5)

(define (double x) (+ x x))

(define (halve x) (/ x 2))

(define (multi a b)
 (cond ((= b 0) 0)
       ((= 0 (remainder b 2)) (double (multi a (halve b))))
       (else (+ a (multi a (- b 1))))))

(multi 2 4)

(define (square x) (* x x))

(define (even x)
  (= (remainder x 2) 0))

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

(fast-prime 38 100)

(define (high-order-fn f x)
  (f x))

(high-order-fn (lambda (x) (* x x)) 2)

(define (F x)
  (let ((a x)(b (+ x 1)))
    (+ a b)))

(define (FF F)
  (lambda (x) (F x)))

((FF (lambda (x) x)) 1)

(define (lx x)  
  (lambda (y) (+ x y)))

(define haha (lx 1))

(haha 3)
