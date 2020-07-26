#lang racket
(provide list-scaler-generator)

;Mystery function
;Hint: It uses good names
(define (list-scaler-generator scale-factor)
  (lambda (list-to-scale)
            (map (lambda (x) (* scale-factor x))
                  list-to-scale)))

((list-scaler-generator 3) '(1 2 3))
; input: a number k (scale-factor)
; output: anonymous function lambda that scales the list list-to-scale by k times
; map: applies lambda to every element of list-to-scale
; lambda: facilitates the mutiplication between k and every element of list-to-scale

