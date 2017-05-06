#lang racket
(define one-to-four (list 1 2 3 4))

(cdr one-to-four)

(cadr one-to-four)

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))

(define squares (list 1 4 9 16 25))

(list-ref squares 3)

(define (length items)
  (define (length-iter items now)
    (if (null? items)
        now
        (length-iter (cdr items) (+ now 1))))
  (length-iter items 0))

(length squares)

(define (append-list list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))

(append-list squares squares)

(define (last-pair l)
  (if (null? (cdr l))
      (car l)
      (last-pair (cdr l))))

(last-pair squares)

(define (reverse-list l)
  (if (null? l)
    null
    (append-list (reverse-list (cdr l)) (list (car l)))))

(reverse-list squares)

(define (scala-list items factor)
  (if (null? items)
      null
      (cons
       (* (car items) factor)
       (scala-list (cdr items) factor))))

(scala-list squares 1.1)

(define (scala-list2 items factor)
  (map (lambda (item) (* factor item)) items))

(scala-list squares 1.1)

(define (square-list items)
  (define (iter items ans)
    (if (null? items)
        ans
        (iter
         (cdr items)
         (append ans (list(* (car items) (car items)))))))
  (iter items null))

(square-list (list 1 2 3 4))

(for-each (lambda (x) (newline)(display x)) squares)

(newline)

(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

(count-leaves (list (list 1 2) (list 3 4)))

(define (fringe tree)
  (cond
    ((null? (cdr tree)) 
      (if (pair? (car tree))
        (fringe (car tree))
        tree))
    ((not (pair? (car tree)))
      (cons (car tree) (fringe (cdr tree))))
    (else
      (append (fringe (car tree))
              (fringe (cdr tree))))))

(fringe (list (list 1 2) (list 3 4)))

(define (deep-reverse tree)
  (cond ((null? tree) null)
        ((not (pair? tree)) tree)
        (else
         (append (deep-reverse (cdr tree))
                 (list(deep-reverse (car tree)))))))

(deep-reverse (list (list 1 2) (list 3 4)))

(define (scale-tree tree factor)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (scale-tree  sub-tree factor)
             (* sub-tree factor)))))

(define (subset s)
  (if (null? s)
      (list null)
      (let ((rest (subset (cdr s))))
        (append rest (map (lambda (x)
                        (cons (car s) x))
                      rest)))))

(define (filter predict sequance)
  (cond ((null? sequance) null)
        ((predict (car sequance))
         (cons (car sequance)
               (filter predict (cdr sequance))))
        (else (filter predict (cdr sequance)))))

(define (accumulate op initial sequance)
  (if (null? sequance)
      initial
      (op (car sequance)
          (accumulate op initial (cdr sequance)))))


(define (enumerate-interval low high)
  (if (> low high)
      null
      (cons low (enumerate-interval (+ low 1) high))))

(define (enumrate-tree tree)
  (cond ((null? tree) null)
        ((not (pair? tree)) (list tree))
        (else (append (enumrate-tree (car tree))
                      (enumrate-tree (cdr tree))))))

(define (count-leaves-2 t)
  (accumulate (lambda (x y) (+ x y))
              0
              (map (lambda(x) 1) (fringe t))))

(define (fold-left op initial sequance)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequance))

(define (reverse-use-fold-left sequance)
  (fold-left (lambda (x y) (cons y x) null sequance)))

(define (reverse-use-fold-right sequance)
  (accumulate (lambda (x y) (append y (list x))) null sequance))


