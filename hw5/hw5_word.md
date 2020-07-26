Thanh Nguyen
Programming Language: homework 5

2. Already having the desugarer for letrec with one binding, we apply the similar mechanism to mutual recursion. This means that a list of syms is car bindings and vals is cdr bindings. Then as each binding has its own set!, we can write a function that returns the lexical replacement of set! for a binding. Then use map to map this function to each of the binding and place the list in a begin statement, before the body.

;Desugar the letrec's in this program
(let 
	([f 0]
	[g 0])
	(begin 
		(set! f (lambda (x) 
			(if (< x 1)
            	1
            	(* 2 (g (- x 1))))))
        (set! g (lambda (x)
          	(+ 1 (f (- x 1)))))
    	(let 
    		([h 0])
    		(begin
	    		(set! h (lambda (x)
		            (if (< x 1)
		                1
		                (+ (f x)
		                   (* x (h (- x 1))))))))
		        (f (h 4)))))

3. 
- Immutable strings:
If string is immutable, the initial data is guaranteed to be unaltered despite multiple processing. This helps making sure the data is safe.  Furthermore, processing a character at a time is costly for immutable string. Considering integral approximation, mutable strings does not help the calculation as each calculation is different. The calculation also can be based on the previous one so immutable data structure favors the process. Disadvantages: unflexible data structure, complicate coding, slower runtime. 

- Mutable string: allows flexible data structure and has better performance for manipulating strings and characters. I am not entirely familiar with how protein sequence is processed, but my impression is that the process alters the strings multiple times, or extract the string for characters. Mutable string is more suitable for protein sequence processing as the string is concatenated. 

4. 
	(define x 3)
	(define y (box 3))
	(define (f a b)
	  (begin
	    (set! x 2)
	    (set-box! b 1)
	    (set! a (+ a (unbox y)))))
	(f x y)

x, y, store contents
i. Call-by-value: 
	x = 2, y = 3
	0A --> 2
	1A --> 3
	2A --> (ptr 1A)
	3A --> closure
	4A --> 4
	5A --> (ptr 6A)
	6A --> 1


ii. Call-by-Reference: 
	x = 3, y = 1
	0A --> 3
	1A --> 3
	2A --> (ptr 4A)
	3A --> closure
	4A --> 1

iii. Call-by-Value-Result
	x = 6, y = 1
	0A --> 6
	1A --> 3
	2A --> (ptr 6A)
	3A --> closure
	4A --> 6
	5A --> (ptr 6A)
	6A --> 1

iv. Call-by-Name
	x = 3, y = 1
	0A --> 3
	1A --> 3
	2A --> (ptr 5A)
	3A --> x
	4A --> y
	5A --> 1
