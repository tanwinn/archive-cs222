#lang racket

;Classwork 8/29
;Thanh (Tan) Nguyen
;CJ Stanton

(define (factorial n)
	(if (nonnegative-integer? n)
		(if [equal? n 1]
		1 
		(* (factorial (- n 1)) n))
		0))

; We finished classwork 1. Our problem is to understand how and when parentheses are placed, 
; to get used to the nature of function definition (funcion args[]), 
; and to understand that Racket is not object-oriented (return statement)