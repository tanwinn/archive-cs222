; CS222 - Programming language
; Dr. Fox
; Thanh Nguyen
; Monday September 3
; Homework 1

#lang racket

; Question 1: 
; Composition f of g 

(define (composition f g)
	(lambda (x) (f (g x)))
)

; Question 2: 
; Write a function called my-reverse that reverses a list.  It should behave identically to the reverse function in Racket, though it must not use reverse.

(define (my-reverse l)
	(if [null? l]
		'()
		(append (my-reverse (rest l)) (list (first l) ))
	)
)

; Question 3:
; Write a function called my-range that takes two integer arguments and outputs a list of all integers in ascending order that are greater than or equal to the first argument and less than the second argument.  (It works like range in Python.)  It should behave identically to the range function in Racket under these conditions, though it must not use range or any of its relatives.

(define (my-range begin end)
	(if [< begin end]
		(append 
			(list begin) 
			(my-range (+ begin 1) end)
		)
		'()
	)
)

; Question 4:
; Input: a number and a BST 

; in-bst
(define (in-bst tree number)
	; base case: when the list is null
	(if [null? tree]
		#f
		(cond [(= number (first tree)) #t]
			[else (or 
				(in-bst (rest (rest tree)) number) 
				(in-bst (first (rest tree)) number)
			)]
		)
	)
)

; add-to-bst
(define (add-to-bst number tree)
	; Check if the number is already in the tree
	(if [in-bst tree number]
		tree
		; Add the number into the tree
		(add-number tree number)
	)
)

(define (add-number tree item)
	(cond 
		; If reach a null, add item
		[(null? tree) 
			(list item '())]

		; If item <= parent, travese to the left child 
		; Else traverse to the right child

		[(<= item (first tree)) 
			(cons 
				(first tree)
				(cons 
					(add-number (first (rest tree)) item) 
					(rest (rest tree))
				)
			)
		]

		[else 
			(cons 
				(first tree)
				(cons 
					(first (rest tree))
					(add-number (rest (rest tree)) item)
				)

			)
		]
	)
)


; Question 5: 
; Vector "class" with (x y z) & magnitude

(define (Vector x y z)
	(lambda (command)
		(cond 
			[(equal? command 'x) x]
			[(equal? command 'y) y]
			[(equal? command 'z) z]
			[(equal? command 'mag) 
				(sqrt (+ (expt x 2) (expt y 2) (expt z 2) ))]
		)
	)
)

; Input vex and k
; Output k*vex vector object
(define (scale-vector vex k)
	(define x (vex 'x))
	(define y (vex 'y))
	(define z (vex 'z))
	(define newVex 
		(Vector (* k x) (* k y) (* k z)))
	newVex
)

; Input 2 vector objects vex1 vex2
; Ouput result of vex1 x vex2
(define (dot-product vex1 vex2)
	(+ (* (vex1 'x) (vex2 'x)) (* (vex1 'y) (vex2 'y)) (* (vex1 'z) (vex2 'z)) )
)

; Question 6: 
; Pascal Triangle 

(define (factorial n)
	(if (nonnegative-integer? n)
		(if [equal? n 1]
		1 
		(* (factorial (- n 1)) n))
		0))

(define (pascal n k)
	(/ 
		(factorial n) 
		(* (factorial k) 
			(factorial (- n k))
		)
	)
)


; MAIN

(displayln "")
(displayln "----------------------------- TESTING ---------------------------------")

(display "1. Composition f of g, with f=x^2, g=x+5, x=3: ")
((composition (lambda (y) (expt y 2)) (lambda (x) (+ x 5))) 3)

(display "2. Reverse list of '(1 2 3 4): ")
(my-reverse(list 1 2 3 4))

(display "3. Result of my-range(9999 10004): ")
(my-range 9999 10004)

(display "4. Result of (in-bst '(3 (1 ()) 7 (4 ())) 4): ")
(in-bst '(3 (1 ()) 7 (4 ())) 4)

(display "4. Result of (in-bst '(3 (1 ()) 7 (4 ())) 34): ")
(in-bst '(3 (1 ()) 7 (4 ())) 34)

(display "4. Add 10 to '(3 (1 ()) 7 (4 ())): ")
(add-to-bst 10 '(3 (1 ()) 7 (4 ())))

(displayln "5. Creating Vector object called vex...")
(displayln "   (Vector 1 1 (sqrt 2))")
(define vex (Vector 1 1 (sqrt 2)))

(display "   - vex z-coordinate: ") 
(vex 'z)
(display "   - vex magnitude: ") 
(vex 'mag)
(displayln "   Scaling vex by k=5... ") 
(display "   - newVex x-coordinate: ") 
((scale-vector vex 5) 'x)

(display "   Dot product of vex and vex: ") 
(dot-product vex vex)

(display "6. Pascal Triangle's value of 8th entry 10th row (pascal 10 8): ")
(pascal 10 8)

(displayln "-------------------------------------------------------------------------")
(displayln "")

(define (f a)
	(if [< a 1]
		a
		void)
)
