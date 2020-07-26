#lang racket

;make-contract function from class
(define (make-contract pred?)
    (lambda (x)
        (if (pred? x)
            x
            (error (format "Contract violation on ~a" x)))))

;Given a nonnegative integer n, convert it to binary.
;Use b bits; pad with leading zeroes.
;The output will be a list of b bits, listed from least to most significant.
;NOTE: This is the reverse order from how you usually think of binary.
;For example, inputting 3 as n and 4 as b outputs '(1 1 0 0), with the
;ones bit on the left.
;It should be an error if n requires more than b bits to convert to binary.	

(define (Nonnegative-Integer? n)
	(and (integer? n) (>= n 0)))

(define (Positive-Integer? n)
	(and (integer? n) (> n 0)))

(define (int-to-binary n b)
	(let 
		([n ((make-contract Nonnegative-Integer?) n)]
		[b ((make-contract Positive-Integer?) b)]) 
		(if [and (zero? (- b 1)) (zero? (quotient n 2))]
			(list (modulo n 2))
	    	(cons (modulo n 2) (int-to-binary (quotient n 2) (- b 1))))))
