#lang racket
(define fai (/ (+ 1 (sqrt 5)) 2))

(define (fib2 n)
  (define (fib-iter a b count)
    (if (= count 0)
        b
        (fib-iter (+ a b) a (- count 1))))
  (fib-iter 1 0 n))

(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))
(- (fib2 20) (/ (expt fai 20) (sqrt 5)))
(define (cube x) (* x x x ))
(define (p x) (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))))
(sine 12.15)
(define (exp3 x n)
  (define (even n)
    (= (remainder n 2) 0))
  (define (exp3-iter a b n)
    (cond ((= n 0) a)
          ((even n) (exp3-iter a (* b b) (/ n 2)))
          (else (exp3-iter (* a b) b (- n 1)))))
  (exp3-iter 1 x n))
(exp3 2 5)