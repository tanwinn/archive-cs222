#lang racket

;Desugaring example from class
;Lexically replace (- a b) with (- a (* -1 b))
(define (desugar expr)
  (cond
    ;Base case: an atom
    [(not (list? expr)) expr]
    ;If we have a 3-item list with -
    ;do that replacement
    [(and (eq? (first expr) '-)
		(= (length expr) 3))
    	(list '+ (desugar (second expr))
	(list '* -1 (desugar (third expr))))]
	[(and (eq? (first expr) '-)
		(= (length expr) 2))
	(list '* -1 (desugar (second expr)))]
    ;It's not -; leave it alone
    [else (cons (first expr) (map desugar (rest expr)))]));

(define (desugar expr)
	(cond 
		[(not (list? expr)) expr]
		; item-list with the first expression is define
		[(and (eq? (first expr) 'define')
			(= (length expr) 3))
		(list 'define 
			(first (second expr))
			(lambda (rest (second expr)) 
			(desugar (third expr)))


(if [= (first expr) 'cond]
	(cond 
		[= (first expr) 'else]

	)

(desugar_cond (list 'cond (rest (rest expr))))