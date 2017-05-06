#lang racket
(define zero
  (lambda (f)
    (lambda (x)
      x)))

(define (add-1 n)
  (lambda (f)
    (lambda (x)
      (f ((n f) x)))))

(define one
  (lambda (f)
    (lambda (x)
      (f x))))

(define two
  (lambda (f)
    (lambda (x)
      (f (f x)))))

(define (add m n)
  (lambda (f)
    (lambda (x)
      ((m f) ((n f) x)))))


(define (reverse-list list)
  (if (null? list)
      null
      (append (reverse (cdr list)) (list (car list)))))

