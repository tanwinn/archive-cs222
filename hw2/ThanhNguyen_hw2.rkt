#lang racket
(require "hw2_p1.rkt")

; Question 1:
((list-scaler-generator 3) '(0 7 4 1 9))

; Question 2:
(define (prime? number) 
	(cond 
		[(>= 1 number) #f]
		[(eq? 2 number) #t]
		[else (zero? 
			(length (filter zero? 
				(map 
					(lambda(x) (modulo number x))
					(range 2 (+ (sqrt number) 1) 1)
				)
			))
		)]
	)
)

(define (prime-generator upper)
	(cond
		[(>= 1 upper) '()]
		[else (filter prime?
				(append (list 2) (range 1 upper 2))
		)]
	)
)

; Question 3:
(define (make-empty-assoc-list)
	(make-list 2 '())
)

;3) An associative list with nothing in it is a list of two copies of the empty list (null).
(define (empty-assoc-list? L)
	(and 
		[null? (first L)]
		[null? (first (rest L))]
	)
)

; The second list consists of their values.
(define (all-number? L)
	(cond 
		[(null? L) #t]
		[(number? (first L)) (all-number? (rest L))]
		[else #f]
	)
)


; The first list consists of symbols
(define (all-symbol? L)
	(cond 
		[(null? L) #t]
		[(symbol? (first L)) (all-symbol? (rest L))]
		[else #f]
	)
)

; 2) No symbol may appear more than once in the first list.
(define (symbol-unique? L)
	(cond 
		[(or (null? L) (null? (rest L)))
			#t]
		[(eq? (first L) (first (rest L))) #f]
		[else (symbol-unique? (rest L))]
	)
)

(define (assoc-list? L)
	(define symbols (first L))
	(define values (first (rest L)))
	(and
		[eq? 
			(length symbols) 
			(length values)
		]
		[all-symbol? symbols]
		[all-number? values]
		[symbol-unique? (sort symbols symbol<?)]
	)
)

; Output the list of symbols in associative list L
(define (assoc-list-syms L)
	(first L)
)

; Output the list of values in associative list L
(define (assoc-list-vals L)
	(first (rest L))
)

; Get the value in associative list L associated with the symbol sym
(define (assoc-list-get L sym)
	(define symbols (first L))
	(define values (first (rest L)))

	(cond
		[(null? symbols) 
			(error "Symbol is not found")]
		[(eq? (first symbols) sym) 
			(first values)]
		[else 
			(assoc-list-get 
				(list (rest symbols) (rest values)) sym)]
	)
)	
