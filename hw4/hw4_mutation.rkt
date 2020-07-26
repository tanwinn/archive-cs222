#lang racket

;Import the environments/stores
(require "hw4_memory.rkt")

;Pointers

;Pointer constructor
;A pointer is a list containing a memory address (which can be any expression)
;preceded by the symbol 'ptr
(define (make-pointer addr)
  (list 'ptr addr))

;Pointer recognizer
;Is obj a pointer?
(define (pointer? obj)
  (and
    [list? obj]
    [eq? (first obj) 'ptr]
    [= (length obj) 2]))

;Given a pointer, retrieve the address stored within it
(define (addr-pointer ptr)
  (if [pointer? ptr] 
    (second ptr)
    (error "Invalid object, object is not a pointer")))

;Pointer dereferencing
;Given a pointer and a store, look up the pointer's address in the store
(define (dereference-pointer ptr sto)
  (cond
    ;Check if first argument is not a pointer; if not, error
    [(not (pointer? ptr))(error "not a pointer")]
    ;Check if second argument is not a store; if not, error
    [(not (store? sto))(error "not a store")]
    ;If both are, look up the pointer's address in the store
    [else (fetch-store sto (addr-pointer ptr))]))

;Helper for inter```preting a bunch of things in sequence
;and adding them to the store one at a time
;Intepret each value in vals and allocate memory for it,
;passing the updated store to the next case
;Outputs a pair (addresses . final store)
(define (store-alloc-all-helper vals env sto so-far)
  (cond
    ;Base case: we've run out of values
    [(null? vals) (cons so-far sto)]
    [else
      ;let for readability
      (let*
          ;Interpret the next value
          ([interp-val-sto (interpret-helper (first vals) env sto)]
          ;The value
          [interp-val (car interp-val-sto)]
          ;The new store
          [interp-sto (cdr interp-val-sto)])
        ;Recursively process the rest, with the new store
        (store-alloc-all-helper (rest vals)
                            env
                            interp-sto
                            (append so-far (list interp-val))))]))

;interpret a bunch of things in sequence
;and add them to the store one at a time
;Outputs a pair (addresses . final store)
(define (store-alloc-all vals env sto)
  (store-alloc-all-helper vals env sto null))

;Static Scoping

;Helper for interpretation
;Also includes an environment and a store
;Interpret expr subject to the bindings of env
(define (interpret-helper expr env sto)
      (cond
        ;Base case: expr is a number
        ;In that case, just return the number
        [(number? expr) (cons expr sto)]
        ;Base case: expr is a symbol
        ;In that case, look it up in env and sto and return its binding
        [(symbol? expr) (cons (lookup-env-store env sto expr) sto)]
        ;Negative base case: expr is not a list
        ;and not one of the above
        ;In that case, we have an error
        [(not (list? expr)) (error (format "Invalid syntax: ~a" expr))]
        ;Sequencing
        [(eq? (first expr) 'begin)
          (let ([dummy (interpret-helper (second expr) env sto)])
            (interpret-helper (third expr) env (cdr dummy)))]
        ;Addition of 2 values
        [(and (eq? (first expr) '+) (= (length expr) 3))
          (let*
              ;Evaluate left term
              ([left-add (interpret-helper (second expr) env sto)]
              ;Left value
              [left-val (car left-add)]
              ;Left store
              [left-sto (cdr left-add)]
              ;Evaluate right term
              [right-add (interpret-helper (third expr) env left-sto)]
              ;Right value
              [right-val (car right-add)]
              ;Right store
              [right-sto (cdr right-add)])
            ;Do the addition and return the final store
            (cons (+ left-val right-val) right-sto))]
        ;Multiplication of 2 values
        [(and (eq? (first expr) '*) (= (length expr) 3))
          (let*
              ;Evaluate left term
              ([left-mult (interpret-helper (second expr) env sto)]
              ;Left value
              [left-val (car left-mult)]
              ;Left store
              [left-sto (cdr left-mult)]
              ;Evaluate right term
              [right-mult (interpret-helper (third expr) env left-sto)]
              ;Right value
              [right-val (car right-mult)]
              ;Right store
              [right-sto (cdr right-mult)])
            ;Do the addition and return the final store
            (cons (* left-val right-val) right-sto))]
        ;let expression
        [(eq? (first expr) 'let)
          ;Create some local variables to keep track of things
          (let*
              ;Bindings, to be processed
              ([bindings (second expr)]
              ;Symbols, which are the first part of each binding
              [syms (map first bindings)]
              ;Values, which are the second part of each binding
              [vals (map second bindings)]
              ;The values might be expressions that need to be interpreted
              [interp-result (store-alloc-all vals env sto)]
              ;Intepreted values
              [interp-vals (car interp-result)]
              ;Store after interpretation
              [intermed-sto (cdr interp-result)]
              ;Need to make a new environment that extends the old one
              [new-env-store (extend-env-with-store syms
                          interp-vals intermed-sto env)]
              ;Extract the environment from above
              [new-env (car new-env-store)]
              ;Extract the store from above
              [new-sto (cdr new-env-store)]
              ;Body of the let
              ;We're assuming it's one line (as it functionally should be)
              [body (third expr)])
            ;What we need to do: interpret the body,
            ;subject to the extended environment
            (interpret-helper body new-env new-sto))]
        ;Boxes
        ;box
        [(and (eq? (first expr) 'box) (= (length expr) 2))
          (let* 
            ([upcoming 
              (interpret-helper (second expr) env sto)] 
              [upcoming-val (car upcoming)]
              [upcoming-sto (cdr upcoming)]
              [new-cell 
                (store-alloc upcoming-sto upcoming-val)]
              [new-sto (car new-cell)]
              [new-addr (cdr new-cell)])
            (cons 
              (make-pointer new-addr)
              new-sto))]
        ;unbox
        ; (unbox 3)
        ; (unbox (ptr))
        ; (unbox (ptr))
        ; (result . final store)
        [(and (eq? (first expr) 'unbox) (= (length expr) 2))
          (let* 
            ([upcoming 
              (interpret-helper (second expr) env sto)] 
              [upcoming-ptr (car upcoming)]
              [upcoming-sto (cdr upcoming)]
              [addr-of-ptr
                (addr-pointer upcoming-ptr)]
              [val-of-ptr (fetch-store upcoming-sto addr-of-ptr)])
            (cons val-of-ptr upcoming-sto))]
        
        ;set-box!
        ; (set-box! b a)
        ; (set-box! (ptr-func) (func))
        [(and (eq? (first expr) 'set-box!) (= (length expr) 3))
          (let*
            ([b (second expr)]
            [a (third expr)]
            [upcoming-b (interpret-helper b env sto)]
            [upcoming-ptr (car upcoming-b)]
            [upcoming-b-sto (cdr upcoming-b)]
            [upcoming-a (interpret-helper a env upcoming-b-sto)]
            [upcoming-addr 
              (addr-pointer upcoming-ptr)]
            [new-val (car upcoming-a)]
            [upcoming-a-sto (cdr upcoming-a)])
          (cons 
            (void)
            (store-mutate upcoming-a-sto upcoming-addr new-val)))]
        ;Variables
        ;set!
        [(and (eq? (first expr) 'set!)
              (= (length expr) 3))
          (let*
              ;Evaluate the new value
              ([upcoming-value-pair (interpret-helper (third expr) env sto)]
              [upcoming-value (car upcoming-value-pair)]
              [upcoming-sto (cdr upcoming-value-pair)]
              ;Mutate the store
              [new-sto (store-mutate upcoming-sto
                                      (lookup-env env (second expr))
                                      upcoming-value)])
            (cons (void) new-sto))]
        ;Is the head of the list a list or symbol
        ;that wasn't a previous case?
        ;If so, interpret it now from the environment
        ;Keeping in mind it might have side effects
        [(or (symbol? (first expr)) (list? (first expr)))
          (let*
            ;Interpret the first of the expression and extract the pieces
            ([interp-sym-pair (interpret-helper (first expr) env sto)]
            [interp-sym-val (car interp-sym-pair)]
            [interp-sym-sto (cdr interp-sym-pair)])
          ;Interpret the whole expression
          (interpret-helper (cons interp-sym-val (rest expr))
                            env
                            interp-sym-sto))]
        ;Otherwise, we don't have a rule, so it's an error
        [else (error (format "Invalid syntax: ~a" expr))]))

;To interpret, call interpret-helper on an empty environment
(define (interpret expr)
  (car (interpret-helper expr
          (make-empty-env)
          (make-empty-store))))
