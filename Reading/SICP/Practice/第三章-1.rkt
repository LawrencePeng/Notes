#lang racket

(define (new-withdraw)
  (let ((balance 100))
    (lambda (amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount)) balance)
          "Insufficient funds"))))

(define (make-withdraw balance)
  (lambda (amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficent funds")))

(define w1 (make-withdraw 100))

(define w2 (make-withdraw 100))

(w1 50)
(w2 70)
(w2 40)
(w1 40)

(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT" m))))
  (dispatch))

(define acc (make-account 100))

((acc 'withdraw) 50)

((acc 'withdraw) 60)

((acc 'deposit) 40)

((acc 'withdraw) 60)

(define acc2 (make-account 100))
