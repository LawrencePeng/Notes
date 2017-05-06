#lang racket
(define (make-rat x y)
  (if (> (/ x y) 0)
      (cons (abs x) (abs y))
      (if (> y 0)
          (cons x y)
          (cons (- 0 x) (- 0 y)))))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))
  
(define (numer n)
  (let ((g (gcd (car n) (cdr n))))
    (/ (car n) g)))

(define (denom n)
  (let ((g (gcd (car n) (cdr n))))
    (/ (cdr n) g)))
          

(define (print-rat n)
  (newline)
  (display (numer n))
  (display "/")
  (display (denom n)))

(print-rat (make-rat -2 -4))


(define (make-interval a b) (cons a b))

(define (upper-bound x)
  (if (> (car x) (cdr x))
      (car x)
      (cdr x)))

(define (lower-bound x)
  (if (> (car x) (cdr x))
      (cdr x)
      (car x)))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (sub-interval x y)
  (abs (- (- (upper-bound x) (lower-bound x))
          (- (upper-bound y) (lower-bound y)))))
