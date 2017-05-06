#lang racket
(define x (list 1 2 3 4))

(define (len li)
  (if (null? li)
      0
      (+ 1 (len (cdr li)))))

(define (get li n)
  (if (= n 0)
      (car li)
      (get (cdr li) (- n 1))))

(get x 2)

(map (lambda (x) (* x x)) '(1 2 3 4))


(len (cons (list 1 2) '(3 4)))
(map (lambda (number)
         (+ 1 number))
       '(1 2 3 4))

(define (leaf-len tree)
  (cond ((null? tree) 0)
        ((not (pair? tree)) 1)
        (else (+ (leaf-len (car tree))
                 (leaf-len (cdr tree))))))

(leaf-len '(1(2(3 4))))


