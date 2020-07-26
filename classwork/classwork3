#lang racket

; Joe MacInnes
; Thanh Nguyen
; October 5th, 2018
(require "hw4_mutation_solution_plus.rkt")


; Desugarer for letrec
(define (desugar expr)
  (let ([f (first (first (second expr)))]
		[binding (second (first (second expr)))]
		[body (third expr)])
  	(cond
	  [(and (eq? (first expr) 'letrec) (= (length expr) 3))
	   		(list 'let
				  (list
					(list f 0))
				  (list 'begin
						(list 'set!
							 f 
							 binding)
						body))])))


(desugar '(letrec ([f (lambda (n) (if (= 0 n) 1 (* n (f (+ n -1)))))]) (f 7)))


; Desugarer for mutual recursion with letrec

;(define (desugar-no-2 expr)
;  (let ([bindings (second expr)]
;        [body (third expr)])
;  (cond
;      [(and (eq? (first expr) 'letrec) (= (length expr) 3))
;		]

; Our thinking is to make a function that will return the lexical replacement
; of set! for a binding. Then, map this function to each of the bindings and 
; place the resulting list in a  begin statement ended by the body.
