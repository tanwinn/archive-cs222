#lang racket

;Import the environments/stores
(require "hw4_memory.rkt")

;Good functions

;Constructor
(define (func params body env)
  (list 'func params body env))

;Identifier
(define (func? obj)
  (and (list? obj)
        (= (length obj) 4)
        (eq? (first obj) 'func)
        (list? (second obj))
        (env? (fourth obj))))

;Parameters
(define (func-params func)
  (if (func? func)
      (second func)
      (error (format "~a not a function" func))))

;Body
(define (func-body func)
  (if (func? func)
      (third func)
      (error (format "~a not a function" func))))

;Environment
(define (func-env func)
  (if (func? func)
      (fourth func)
      (error (format "~a not a function" func))))

;Third, successful, attempt: Static Scoping
;Now, also need to pass a store
(define (eval-func func args sto)
  (if (func? func)
      (let*
          ;New environment
          ([new-env-store (extend-env-with-store (func-params func)
                                      args
                                      sto
                                      (func-env func))]
          ;Extract the environment from above
          [new-env (car new-env-store)]
          ;Extract the store from above
          [new-sto (cdr new-env-store)])
        (interpret-helper (func-body func) new-env new-sto))
      (error (format "~a not a function" func))))


;Pointers

;Pointer constructor
;A pointer is a list containing a memory address (which can be any expression)
;preceded by the symbol 'ptr
(define (make-pointer addr)
  (list 'ptr addr))

;Pointer identifier
;Is obj a pointer?
(define (pointer? obj)
  (and (list? obj) (= (length obj) 2) (eq? (first obj) 'ptr)))

;Given a pointer, retrieve the address stored within it
(define (addr-pointer ptr)
  (if (pointer? ptr)
      (second ptr)
      (error (format "Pointer expected: ~a" ptr))))

;Pointer dereferencing
;Given a pointer and a store, look up the pointer's address in the store
(define (dereference-pointer ptr sto)
  (cond
    ;Check if first argument is not a pointer; if not, error
    [(not (pointer? ptr)) (error (format "Pointer expected: ~a" ptr))]
    ;Check if second argument is not a store; if not, error
    [(not (store? sto)) (error (format "Store expected: ~a" sto))]
    ;If both are, look up the pointer's address in the store
    [else (fetch-store sto (addr-pointer ptr))]))

;Helper for interpreting a bunch of things in sequence
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
        ; (unbox (ptr))
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
        ; let-alias
        [(eq? (first expr) 'let-alias)
          (let* 
            ; Bindings
            ([bindings (second expr)]
            [alias (first (first bindings))]
            [var (second (first bindings))]
            [ptr-to-var (lookup-env env var)]
            ; Extend the environment with alias binds to ptr-to-var
            [new-env 
              (extend-env (list alias) (list ptr-to-var) env)]
            ; Body of the let
            [body (third expr)])
            (interpret-helper body new-env sto))]
        ;lambda expression
        [(eq? (first expr) 'lambda)
          ;Create some local variables to keep track of things
          (let
              ;Function parameters
              ([params (second expr)]
              ;Function body
              [body (third expr)])
            ;Create a func object and return it
            (cons (func params body env) sto))]
        ;func
        [(func? (first expr))
          (let*
              ;Extract the arguments
              ([args (rest expr)]
              ;Interpret the arguments and store them
              [arg-eval-sto (store-alloc-all args env sto)]
              ;Extract the evaluated arguments
              [arg-eval (car arg-eval-sto)]
              ;Extract the new store
              [arg-sto (cdr arg-eval-sto)])
            (eval-func (first expr) arg-eval arg-sto))]
        ;Boxes
        ;box
        [(and (eq? (first expr) 'box) (= (length expr) 2))
          (let*
              ;Evaluate the thing going into the box
              ([box-value-pair (interpret-helper (second expr) env sto)]
              [box-value (car box-value-pair)]
              [box-store (cdr box-value-pair)]
              ;Allocate a memory cell for the box
              [box-alloc (store-alloc box-store box-value)]
              [new-sto (car box-alloc)]
              [box-addr (cdr box-alloc)])
            (cons (make-pointer box-addr) new-sto))]
        ;unbox
        [(and (eq? (first expr) 'unbox)
              (= (length expr) 2))
            (let*
              ;Evaluate the thing that should be a box/pointer
              ([box-pair (interpret-helper (second expr) env sto)]
              [the-box (car box-pair)]
              [new-sto (cdr box-pair)])
          (if (pointer? the-box)
              (cons (dereference-pointer the-box new-sto) new-sto)
              (error (format "Pointer expected: ~a" the-box))))]
        ;set-box!
        [(and (eq? (first expr) 'set-box!)
              (= (length expr) 3))
          (let*
              ;Evaluate the thing that should be a box/pointer
              ([box-pair (interpret-helper (second expr) env sto)]
              [the-box (car box-pair)]
              [box-sto (cdr box-pair)])
            (if (pointer? the-box)
                (let*
                    ;Evaluate the new value
                    ([upcoming-value-pair (interpret-helper (third expr)
                                                            env
                                                            box-sto)]
                    [upcoming-value (car upcoming-value-pair)]
                    [upcoming-sto (cdr upcoming-value-pair)]
                    ;Mutate the store
                    [new-sto (store-mutate upcoming-sto
                                            (addr-pointer the-box)
                                            upcoming-value)])
                  (cons (void) new-sto))
                (error (format "Pointer expected: ~a" the-box))))]
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
