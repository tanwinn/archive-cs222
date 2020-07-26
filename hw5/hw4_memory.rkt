#lang racket

;This file contains associative lists, environments, and stores

;Associative lists
(provide make-empty-assoc-list empty-assoc-list? assoc-list?)
(provide assoc-list-syms assoc-list-vals assoc-list-get)
(provide in-assoc-list? make-assoc-list assoc-list-put)
(provide assoc-list-del)

;Associative lists

;Empty associative list
(define (make-empty-assoc-list) (cons null null))

;Associative list constructor
(define (make-assoc-list syms vals)
  (cond
    ;Do the lists have the same length?
    [(not (= (length syms) (length vals)))
      (error "Lists must have same length")]
    ;Does the syms list have duplicates?
    [(check-duplicates syms)
      (error "Symbols list must not contain duplicates")]
    ;Ok, good to go!
    [else (cons syms vals)]))

;Is it the empty associative list?
(define (empty-assoc-list? L)
  (cond
    [(equal? L (make-empty-assoc-list)) #t]
    [else #f]))

;Is it an associative list?
(define (assoc-list? L)
  (cond
    ;Positive base case: It's the empty associative list
    [(empty-assoc-list? L) #t]
    ;Negative base case: It's not a pair
    [(not (pair? L)) #f]
    ;Negative base case: car is not a list
    [(not (list? (car L))) #f]
    ;Negative base case: cdr is not a list
    [(not (list? (cdr L))) #f]
    ;Negative base case: one half of L is empty
    [(or (null? (car L)) (null? (cdr L))) #f]
    ;Negative base case: there are duplicates among the symbols
    [(check-duplicates (car L)) #f]
    ;Recursive step: Is the rest an associative list?
    ;NO LONGER REQUIRED TO BE SYMBOLS ON LEFT!
    [else (assoc-list? (cons (cdar L) (cddr L)))]))

;Get the symbols of the associative list L
(define (assoc-list-syms L)
  (car L))

;Get the values of the associative list L
(define (assoc-list-vals L)
  (cdr L))

;Get the associated value to sym in associative list L
(define (assoc-list-get L sym)
  ;Give the symbols and values names for ease of reference
  (let
    ([syms (assoc-list-syms L)]
    [vals (assoc-list-vals L)])
    (cond
      ;Negative base case: Is the list empty?
      [(empty-assoc-list? L) (error (format "symbol not in list: ~a" sym))]
      ;Positive base case: Is the queried symbol at the head?
      ;If so, get the value
      [(equal? (first syms) sym) (first vals)]
      ;Recursive case: Look in the rest of the associative list
      [else (assoc-list-get (cons (rest syms) (rest vals)) sym)])))

;Is the given symbol in the associative list?
(define (in-assoc-list? L sym)
  (if (member sym (assoc-list-syms L))
        #t
        #f))

;Associate symbol sym with value val in associative list L
(define (assoc-list-put L sym val)
  ;Give the symbols and values names for ease of reference
  (let
    ([syms (assoc-list-syms L)]
    [vals (assoc-list-vals L)])
    (cond
      ;Negative base case: Is the list empty?
      [(empty-assoc-list? L) (cons (list sym) (list val))]
      ;Positive base case: Is the queried symbol at the head?
      ;If so, put in the new value
      [(equal? (first syms) sym) (cons syms (cons val (rest vals)))]
      ;Recursive case: Look in the rest, and keep what's there already
      [else (let*
              ;Do the recursive call and give the new symbols and values
              ;names in a let, for ease of reference
              ([put-rest-of-L
                  (assoc-list-put (cons (rest syms) (rest vals)) sym val)]
                [new-syms (assoc-list-syms put-rest-of-L)]
                [new-vals (assoc-list-vals put-rest-of-L)])
              ;Tack the current heads of the two lists onto the
              ;recursively-generated things
              (cons (cons (first syms) new-syms)
                    (cons (first vals) new-vals)))])))

;Remove symbol sym and its association from the associative list
(define (assoc-list-del L sym)
  ;Give the symbols and values names for ease of reference
  (let
    ([syms (assoc-list-syms L)]
    [vals (assoc-list-vals L)])
    (cond
      ;Negative base case: Is the list empty?
      ;If so, error, since can't remove symbol
      [(empty-assoc-list? L)
        (error (format "Error: ~a not in associative list" sym))]
      ;Positive base case: Is the queried symbol at the head?
      ;If so, remove it (return the rest of the associative list)
      [(equal? (first syms) sym) (cons (rest syms) (rest vals))]
      ;Recursive case: Look in the rest, and keep what's there already
      [else (let*
              ;Do the recursive call and give the new symbols and values
              ;names in a let, for ease of reference
              ([del-rest-of-L
                  (assoc-list-del (cons (rest syms) (rest vals)) sym)]
                [new-syms (assoc-list-syms del-rest-of-L)]
                [new-vals (assoc-list-vals del-rest-of-L)])
              ;Tack the current heads of the two lists onto the
              ;recursively-generated things
              (cons (cons (first syms) new-syms)
                    (cons (first vals) new-vals)))])))


;Environments

(provide make-empty-env extend-env empty-env? env?)
(provide extended-env? get-env-assoc-list get-old-env)
(provide lookup-env)

;Create an empty environment
(define (make-empty-env) 'empty-env)

;Extend the given environment with the given associative list
(define (extend-env syms vals old-env)
    (cons (make-assoc-list syms vals) old-env))

;Is the given thing an empty environment?
(define (empty-env? env)
    (equal? env (make-empty-env)))

;Is the given thing an extended environment?
(define (extended-env? env)
    (and
        ;Is it a pair?
        (pair? env)
        ;Is the car an associative list?
        (assoc-list? (car env))
        ;Is the cdr an environment?
        (or (empty-env? (cdr env)) (extended-env? (cdr env)))))

;Is the given thing an environment?
(define (env? env)
    (or (empty-env? env) (extended-env? env)))

;Get the associative list from the environment
(define (get-env-assoc-list env)
    (cond
        ;Was an extended environment passed?
        [(not (extended-env? env))
            (error (format "Extended environment expected, received ~a"
                            env))]
        [else (car env)]))

;Get the old environment from the environment
(define (get-old-env env)
    (cond
        ;Was an extended environment passed?
        [(not (extended-env? env))
        (error (format "Extended environment expected, received ~a"
                        env))]
        [else (cdr env)]))

;Look-up in environment
(define (lookup-env env sym)
    (cond
        ;Check 1: is it an environment?
        [(not (env? env)) (error (format "Environment expected: ~a" sym))]
        ;Check 2: is it empty?
        [(empty-env? env) (error (format "Unbound variable: ~a" sym))]
        ;Check 3: is it in the outermost associative list?
        [(in-assoc-list? (get-env-assoc-list env) sym)
            (assoc-list-get (get-env-assoc-list env) sym)]
        ;None of the above. Dig deeper
        [else (lookup-env (get-old-env env) sym)]))

;Stores

(provide make-empty-store empty-store? store?)
(provide store-alloc fetch-store store-mutate)
(provide store-dealloc)

;Create an empty store
(define (make-empty-store) (make-empty-assoc-list))

;Is the given thing an empty store?
(define (empty-store? sto)
    (equal? sto (make-empty-store)))

;Is the given thing a store?
(define (store? sto)
    (assoc-list? sto))

;Allocate a new memory cell and put the value there
(define (store-alloc sto val)
    ;Get the next address
    ;Doing this the inefficient way that works
    (let*
        ;Step 1: extract the numerical addresses
        ;For now, this is all of them
        ([num-addrs (filter number? (assoc-list-syms sto))]
        ;Step 2: If there are none, use address 0
        ;Otherwise, use the next number
         [next-addr
            (if (null? num-addrs)
                0
                (+ 1 (apply max num-addrs)))])
        ;Output a pair: (new store . newly allocated address)
        (cons (assoc-list-put sto next-addr val) next-addr)))

;Retrieve the value in the given memory address
(define (fetch-store sto addr)
    (assoc-list-get sto addr))

;Change the value in the given address of the store
;to be the given value
(define (store-mutate sto addr new-val)
    ;Check to make sure we can mutate it
    (if (in-assoc-list? sto addr)
        ;Yes. Then mutate it
        (assoc-list-put sto addr new-val)
        ;No. It hasn't been allocated
        (error (format "Error: address ~a does not exist" addr))))

;Given an address, de-allocated it
(define (store-dealloc sto addr)
  ;Check to make sure we can de-allocate it
  (if (in-assoc-list? sto addr)
      ;Yes. Then remove it
      (assoc-list-del sto addr)
      ;No. It hasn't been allocated
      (error (format "Error: address ~a does not exist" addr))))

;Environments and stores working together

(provide lookup-env-store extend-env-with-store)

;Lookup symbol in environment and store
(define (lookup-env-store env sto sym)
  (fetch-store sto (lookup-env env sym)))

;Helper function for extending an environment with
;allocating in store
(define (extend-env-with-store-helper syms vals sto old-env addrs-so-far)
  (cond
    ;We're done when there's no more values to allocate
    [(null? vals) (cons (extend-env syms addrs-so-far old-env) sto)]
    [else
      ;let for readability
      ;First: allocate the new memory
      (let* ([alloc-pair (store-alloc sto (first vals))]
            ;The new store
            [new-sto (car alloc-pair)]
            ;The new address
            [new-addr (cdr alloc-pair)])
          ;Recursive call with the new info
          (extend-env-with-store-helper syms
            (rest vals)
            new-sto
            old-env
            (append addrs-so-far (list new-addr))))]))

;Extend an environment with allocating in store
;Ouputs a pair (environment . store)
(define (extend-env-with-store syms vals sto old-env)
  (extend-env-with-store-helper syms vals sto old-env null))
