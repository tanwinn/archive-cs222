#lang racket
(define (collatz x)
    (if (= (modulo x 2) 0)
        (quotient x 2)
        (+ (* x 3) 1)))
