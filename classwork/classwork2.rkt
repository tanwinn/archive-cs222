; CS222 - Programming Language
; Thanh Nguyen & Robert Alvarez

#lang racket

; Question 1:
; write function to approximate pi using a given input number of terms from the formula 
; pi = 4*(1-1/3+1/5-1/7+1/9-...)
; = 4* ((2*0+1)^-1 - (2*1+1)^-1 + (2*2+1)^-1 - ...)
; = 4*(-1)^i*(2*i+1)^-1
; for i in range(n): pi+= 4*((-1)^i)*(2*i+1)^-1

(define (pine n)
	(foldl +
		0
		(map (lambda (x)
			(* 4 (* (expt -1 x)
				(expt (+ 1 (* 2 x)) -1 ))))
		(range n) ))
)


;Question 2: my-list-ref
;Given an index n and a list L
;output the nth element of L
;Indices start from 0

(define (nth-elem n L)
	(cond 
		[(= n 0)(first L)]
		[(equal? (rest L) null) (error "Doesn't have the element")]
		[else (nth-elem (- n 1) (rest L))])
)
