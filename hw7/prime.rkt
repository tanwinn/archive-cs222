#lang typed/racket

; Question 1:

(: prime?
	(-> Nonnegative-Integer Boolean))

(: prime-generator 
	(-> Nonnegative-Integer 
		(Listof Nonnegative-Integer)))

(: prime-factor 
	(-> Nonnegative-Integer 
	(Listof Nonnegative-Integer)))

(: prime-factor-helper
	(-> Nonnegative-Integer 
	(Listof Nonnegative-Integer)
	(Listof Nonnegative-Integer)))

(define (prime? number)
	(cond 
		[(>= 1 number) #f]
		[(eq? 2 number) #t]
		[else (zero? 
			(length (filter zero? 
				(map 
					(lambda ([x : Integer]) (modulo number x))
					(range 2 (+ (sqrt number) 1) 1)))))]))

(define (prime-generator upper)
	(cond
		[(>= 1 upper) '()]
		[else (filter prime?		
				(append (list 2) (range 1 (+ upper 1) 2)))]))

(define (prime-factor number)
	(: prime-list (Listof Nonnegative-Integer))
	(define prime-list 
		(prime-generator number))
	(prime-factor-helper number prime-list))

(define (prime-factor-helper number prime-list)
	(: current-prime Nonnegative-Integer)
	(define current-prime (first prime-list))
	
	(cond 
		[(<= number 1) '()]

		; if current-prime in the prime list divides number, then add current-prime to list and divides number
		[(zero? (modulo number current-prime))
			(append 
				(list current-prime) 
				(prime-factor-helper 
					(quotient number current-prime)
					prime-list))]
		
		; else if current-prime doesn't divdes number, then move on to the next elem in prime-list
		[else 
			(prime-factor-helper 
				number (rest prime-list))]))

