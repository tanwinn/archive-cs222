#lang racket

;Import the environments module
;This file is Dr. Fox's full version, with HW3 Problem 3 solved
(require "hw4_memory.rkt")

;Closures

;Constructor
(define (func params body env)
  (list 'func params body env))

;Identifier
(define (func? obj)
  (and [list? obj]
    [eq? (first obj) 'func]
    [list? (second obj)]
    [env? (fourth obj)]))

;Parameters
(define (func-params func)
  (if [func? func]
    (second func)
    (error (format "~a is invalid: Not a func object!" func))))

;Body
(define (func-body func)
  (if [func? func]
    (third func)
    (error (format "~a is invalid: Not a func object!" func))))

;Environment
(define (func-env func)
  (if [func? func]
    (fourth func)
    (error (format "~a is invalid: Not a func object!" func))))

;Third, successful, attempt: Static Scoping
(define (eval-func func args)
  (if 
    [and (func? func)
      (= (length (func-params func)) (length args))]
      (let 
        ([env 
          (extend-env 
            (func-params func)
            args
            (func-env func))])
        (interpret-helper (func-body func) env))
      (error (format "~a is invalid" func))))

;Helper for interpretation with static scoping
;Also includes an environment
;Interpret expr subject to the bindings of env
(define (interpret-helper expr env)
  ;This let is here so we can use map with interpret-helper
  ;recursively with the same environment env
  ;without having to awkwardly make lists of env
  (let ([interp-rec (lambda (new-expr)
                        (interpret-helper new-expr env))])
      (cond
        ;Base case: expr is a number
        ;In that case, just return the number
        [(number? expr) expr]
        ;Base case: expr is a symbol
        ;In that case, look it up in env and return its binding
        [(symbol? expr) (lookup-env env expr)]
        ;Negative base case: expr is not a list
        ;and not one of the above
        ;In that case, we have an error
        [(not (list? expr)) (error (format "Invalid syntax: ~a" expr))]
        ;Addition
        [(eq? (first expr) '+)
          (apply + (map interp-rec (rest expr)))]
        ;Multiplication
        [(eq? (first expr) '*)
          (apply * (map interp-rec (rest expr)))]
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
              [interp-vals (map interp-rec vals)]
              ;Need to make a new environment that extends the old one
              [new-env (extend-env syms interp-vals env)]
              ;Body of the let
              ;We're assuming it's one line (as it functionally should be)
              [body (third expr)])
            ;What we need to do: interpret the body,
            ;subject to the extended environment
            (interpret-helper body new-env))]
        ;lambda expression
        [(eq? (first expr) 'lambda)
            (let 
              ([params (second expr)]
               [body (third expr)])
                ; create a new func object
                  (func params body env))]
        ;func
        [(func? (first expr))
          (eval-func 
            (first expr)
            (map 
              interp-rec
              (rest expr)))
        ]
        ;Is the head of the list a list or symbol
        ;that wasn't a previous case?
        ;If so, interpret it now from the environment
        [(or (symbol? (first expr)) (list? (first expr)))
          (interp-rec (cons (interp-rec (first expr))
                            (rest expr)))]
        ;Otherwise, we don't have a rule, so it's an error
        [else (error (format "Invalid syntax: ~a" expr))])))

;To interpret, call interpret-helper on an empty environment
(define (interpret expr)
  (interpret-helper expr (make-empty-env)))
