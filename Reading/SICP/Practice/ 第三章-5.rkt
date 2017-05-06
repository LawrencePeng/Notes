#lang racket
(define stream-car stream-first)

(define stream-cdr stream-rest)

(define (integers-starting-from n)
  (stream-cons n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

(define (divisible? x y) (= (remainder x y) 0))

(define no-sevens
  (stream-filter (lambda (x) (not (divisible? x 7)))
  integers))

(stream-ref no-sevens 100)

(define ones (stream-cons 1 ones))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define integers-2 (stream-cons 1 (add-streams ones integers-2)))

(define fibs
  (stream-cons 0
               (stream-cons 1
                            (add-streams (stream-cdr fibs)
                                         (fibs)))))

(define (scale-stream streams factor)
  (stream-map (lambda (x) (* x factor)) (streams)))

(define double (stream-cons 1 (scale-stream double 2)))

(define (sqrt-stream x)
  (define guesses
    (stream-cons 1.0
                 (stream-map (lambda (guess)
                               (sqrt-improve guess x))
                             guesses)))
  guesses)

(define (average v1 v2)
  (/ (+ v1 v2) 2))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))


