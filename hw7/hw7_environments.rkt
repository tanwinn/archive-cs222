#lang typed/racket

;Associative lists
(define-type (AssocListof A B) (Listof (Pairof A B)))
;Type declarations for associative list functions
(: make-empty-assoc-list (All (A B) (-> (AssocListof A B))))
(: empty-assoc-list? (All (A B) (-> (AssocListof A B) Boolean)))
(: assoc-list-syms (All (A B) (-> (AssocListof A B) (Listof A))))
(: assoc-list-vals (All (A B) (-> (AssocListof A B) (Listof B))))
(: assoc-list-get (All (A B) (-> (AssocListof A B) A B)))
(: make-assoc-list (All (A B) (-> (Listof A) (Listof B) (AssocListof A B))))
(: in-assoc-list? (All (A B) (-> (AssocListof A B) A Boolean)))

;Make empty associative list

(define (make-empty-assoc-list) null)

;Given an associative list, is it empty?
(define (empty-assoc-list? L) (null? L))

;Get the symbols from an associative list
;For whatever reason, the typechecker doesn't like mapping car
;So, here's a solution longer than (define (assoc-list-syms L) (map car L))
(define (assoc-list-syms L)
  (cond
    [(null? L) null]
    [else (cons (caar L) (assoc-list-syms (rest L)))]))

;Get the values from an associative list
(define (assoc-list-vals L)
  (cond
    [(null? L) null]
    [else (cons (cdar L) (assoc-list-vals (rest L)))]))

;Given a list of symbols and a list of values
;Create an associative list with those symbols and values
(define (make-assoc-list syms vals)
  (cond
    ;Make sure no duplicate symbols
    [(check-duplicates syms) (error "Error: syms can't contain duplicates")]
    ;Positive base case: both lists are empty
    [(and (null? syms) (null? vals)) null]
    ;Negative base case: one list is empty
    [(or (null? syms) (null? vals)) (error "Error: lists don't have same length")]
    ;Recursive step: associate the first key to the first value
    ;and call make-assoc-list recursively on the rest
    [else (cons (cons (first syms) (first vals))
                (make-assoc-list (rest syms) (rest vals)))]))

;Given an associative list and a symbol, look up the corresponding value
(define (assoc-list-get L sym)
  (cond
    ;Negative base case: L is empty, so can't find the key
    [(empty-assoc-list? L) (error (format "Error: key ~a not in list" sym))]
    ;Positive base case: found it!
    [(equal? sym (caar L)) (cdar L)]
    ;Recursive step: sym is not the first symbol; recurse on the rest
    [else (assoc-list-get (cdr L) sym)]))

;Given an associative list and a symbol, is the symbol a key in the list?
(define (in-assoc-list? L sym)
  (if (member sym (assoc-list-syms L))
        #t
        #f))

; Union type/ Recursive type
; Type Environment is a union of type 
	; either empty envionemnt
	; or pair of an assoc-list and env --> recursive

(define-type Env 
	(U 'empty-env 
		(Pairof (AssocListof Symbol Any) Env)
	))

;============= TYPE DECLARATION ===================================

;Type declarations for environment functions

(: make-empty-env (-> Env))

(: empty-env? (-> Env Boolean))

(: extended-env? (-> Env Boolean))

(: extend-env (-> (Listof Symbol) (Listof Any) Env Env))

(: get-old-env (-> Env Env))

(: get-env-assoc-list (-> Env (AssocListof Symbol Any)))

(: lookup-env (-> Env Symbol Any))



;Definitions for environment functions

(define (make-empty-env) 'empty-env)

(define (empty-env? env)
	(eq? env (make-empty-env)))

(define (extended-env? env)
	(and
		;Is it a pair?
		(pair? env)
		;(assoc-list? (car env))
        ;Is the cdr an environment?
        (or (empty-env? (cdr env)) (extended-env? (cdr env)))))

(define (extend-env syms vals old-env)
    (cons (make-assoc-list syms vals) old-env))

(define (get-old-env env)
	(if [pair? env]
		(cond
	        ;Was an extended environment passed?
	        [(not (extended-env? env))
	        (error (format "Extended environment expected, received ~a"
	                        env))]
	        [else (cdr env)])
	    (error (format "Environment expected, received ~a" env))))

(define (get-env-assoc-list env)
	(if [pair? env]
	    (cond
	        ;Was an extended environment passed?
	        [(not (extended-env? env))
	            (error (format "Extended environment expected, received ~a"
	                            env))]
	        [else (car env)])
	    (error (format "Environment expected, received ~a" env))))

(define (lookup-env env sym)
	(if [pair? env]
	    (cond
	        ;Check 2: is it empty?
	        [(empty-env? env) (error "Unbound variable")]
	        ;Check 3: is it in the outermost associative list?
	        [(in-assoc-list? (get-env-assoc-list env) sym)
	            (assoc-list-get (get-env-assoc-list env) sym)]
	        ;None of the above. Dig deeper
	        [else (lookup-env (get-old-env env) sym)])
    	(error (format "Environment expected, received ~a" env))))
