#lang racket

(define (+ L [s ""])
	(if [null? (rest L)]
		(string-append s (first L))
		(+ (rest L) (string-append s (first L)))
	)
)