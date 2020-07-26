#lang racket

; Thanh Nguyen & Eric Gabriel
; Classwork 4

(define (make-empty-store)
	(list))

(define (empty-store? obj)
	(and (null? obj) (list? obj)))

(define (store? obj)
	(list? obj)
)

(define (store-alloc sto val)
	(let ([new-sto (append sto (list val))])
		(cons new-sto 
			(- (length new-sto) 1))))